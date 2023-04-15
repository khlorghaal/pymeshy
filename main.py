from com import *
from time import *
from math import *

ANIM= True
DANCE= True
frame=0# int #set manually if anim is off
t= 0 #float seconds

#w= 2560
#h= 1440
w,h= (int(2560//3),1440//2)#dev
#w,h= (2560,1440)
#w,h= (3840,2160)#4k
#w,h= (9075,6201)#poster

import numpy as np
import png
#import exr

import pygame
from pygame.locals import *

import ctypes as ct
from OpenGL.GL import *
from OpenGL.GL import shaders
from OpenGL.GL.EXT.texture_filter_anisotropic import *

def arr(*a):
	return np.array(a)

display= pygame.display
pygame.init()
display.gl_set_attribute(pygame.GL_ACCELERATED_VISUAL, 1)
display.gl_set_attribute(pygame.GL_CONTEXT_MAJOR_VERSION, 4)
display.gl_set_attribute(pygame.GL_CONTEXT_MINOR_VERSION, 5)
display.gl_set_attribute(pygame.GL_CONTEXT_PROFILE_MASK, pygame.GL_CONTEXT_PROFILE_CORE)
#display.gl_set_attribute(pygame.GL_CONTEXT_DEBUG_FLAG, 1)
display.gl_set_attribute(pygame.GL_FRAMEBUFFER_SRGB_CAPABLE, 1)

resolution= (w,h)
pygame.display.set_mode(resolution, DOUBLEBUF | OPENGL)
pygame.display.set_caption('____________________________')

'''
from ctypes import *
def py_cmp_func(a, b):
	print((a,b))
	return
cmp_func = CFUNCTYPE(
	None, # void ; ctypes using None to represent void is shockingly undocumented
	c_size_t,# GLenum source
	c_size_t,# GLenum type
	c_int,# GLuint id
	c_size_t,# GLenum severity
	c_int,# GLsizei length
	POINTER(c_char),# const GLchar* message
	POINTER(c_size_t)# const void* userParam)
	)(py_cmp_func)
glDebugMessageCallback(cmp_func,c_voidp(0))
glEnable(GL_DEBUG_OUTPUT)
glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS)
'''

img= None
tex= None
def loadtex():
	global img
	try:
		img= png.Reader('tex.png').read() #(width, height, values, info)
		img_w= img[0]
		img_h= img[1]
		img_rast= np.flip(np.array(list(img[2]),dtype='uint8'),0).flatten()
		assert(len(img_rast)==img_w*img_h*4)
	except Exception as e:
		print(e)
		img_rast= np.zeros(w*h*4)

	global tex
	if tex!=None:
		glDeleteTextures(tex)
	tex= glGenTextures(1)
	glBindTexture(GL_TEXTURE_2D, tex);
	glActiveTexture(GL_TEXTURE0)
	MIPS= 4
	glTexStorage2D(GL_TEXTURE_2D, MIPS, GL_SRGB8, img_w,img_h)#memory uninitialized, inits mipmap level range
	glTexSubImage2D(GL_TEXTURE_2D, 0,0,0, img_w,img_h, GL_RGBA, GL_UNSIGNED_BYTE, img_rast)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_ANISOTROPY_EXT, MIPS)
	glGenerateMipmap(GL_TEXTURE_2D)


prog_outer= None
prog_inner= None
def loadprogs():
	def a(frag):
		with open("com.glsl") as f:
			com= f.read()
		with open("panopticube.vsh") as f:
			vsh_src= f.read()
		with open(frag) as f:
			fsh_src= f.read()
		try:
			pp= lambda f,D: ''.join([
				'#version 430\n',
				com,
				*['#define %s 1\n'%d for d in D],
				'#line 1\n',
				f
			])
			vsh_src= pp(vsh_src,[])
			fsh_src= pp(fsh_src,[])
			v_p= shaders.compileShader(vsh_src, GL_VERTEX_SHADER)
			f_p= shaders.compileShader(fsh_src, GL_FRAGMENT_SHADER)
			p= shaders.compileProgram(v_p,f_p)
			return p

		except Exception as e:
			print('\nSHADERROR\n')
			e= str(e)[:500]
			e= e.replace('\\\\n','\n')
			e= e.replace(  '\\n','\n')
			e= e.replace(  '\\t','\t')
			e= e.replace(  '\\t','\t')
			e= e.replace(  '\\','')
			e= e.replace('\\\\','')#fuck
			print(e)
			exit()
			return 'failure'
	global prog_inner
	global prog_outer
	prog_inner= a("panopticube_inner.fsh")
	prog_outer= a("panopticube_outer.fsh")

import obj
mesh= obj.load('cube_uvn.obj')
#mesh= obj.load('caveblocks.obj')



appstart= perf_counter()
profile_start= perf_counter()

glViewport(0,0,w,h)

import viewmat
view= viewmat.state()
#view.m[1]= -.2#initial rotation
view.m[0]= 3/8
view.m[1]= 1/4.5

def render():
	glClearColor(0,0,0,0)
	glClear(GL_COLOR_BUFFER_BIT+GL_DEPTH_BUFFER_BIT)

	glUseProgram(prog_inner)

	#dance
	if ANIM and DANCE:
		view.m[0]+= sin(t* 6  )*.008  \
				   +sin(t*  .6)*.005
		view.m[1]+= cos(t*14  )*.015

	vm= view.do(w,h)
	mmv= vm.v
	mp=  vm.p
	glUniformMatrix4fv(0,1,True,mmv)
	glUniformMatrix4fv(1,1,True,mp)
	glUniform1f(2, t) #t
	glUniform3f(3, 0.05,0.05,0.05)#ambient
	glUniform3f(4, 0.1 ,0.6 ,1.  )#reflective
	glUniform3f(5, 0.7 , .85,0.95)#albedo
	glUniform1f(6, .5 ) #rough
	glUniform1f(7, 1.2) #IOR
	glUniform1f(8, .4) #fresnel magnitude

	glEnable(GL_BLEND)
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)#transparent

	glEnable(GL_DEPTH_TEST)
	glDepthFunc(GL_LESS)

	glEnable(GL_CULL_FACE)
	glFrontFace(GL_CW)

	mesh()

	glUseProgram(prog_outer)
	vm= view.do(w,h)#outer cube
	mmv[ 0]*= 1.5#fuck god forgive me 
	mmv[ 1]*= 1.5
	mmv[ 2]*= 1.5
	mmv[ 4]*= 1.5
	mmv[ 5]*= 1.5
	mmv[ 6]*= 1.5
	mmv[ 8]*= 1.5
	mmv[ 9]*= 1.5
	mmv[10]*= 1.5
	glUniformMatrix4fv(0,1,True,mmv)
	glUniformMatrix4fv(1,1,True,mp)
	glUniform1f(2, t) #t
	glUniform3f(3, 0.05,0.05,0.05)#ambient
	glUniform3f(4, 0.2 ,0.2 ,.2  )#reflective
	glUniform3f(5, 0.7 , .85,0.95)#albedo
	glUniform1f(6, .1 ) #rough
	glUniform1f(7, 1.2) #IOR
	glUniform1f(8, .4) #fresnel magnitude

	mesh()

	pygame.display.flip()

loadprogs()
mdown= False
def loop():
	global t
	global frame
	while 1:
		#view.update()
		render()
		if ANIM:
			t= perf_counter()-appstart
			frame+=1
		sleep(1./60.)
		if frame%30==0: #recompile all the t lmao
			#todo file modify hook
			try:
				loadprogs()
				loadtex()
			except Exception as e:
				print('bad '+str(e))

		#input
		for e in pygame.event.get():
			if (e.type == QUIT) or (e.type == KEYUP and e.key == K_ESCAPE):
				return
			if e.type==MOUSEMOTION:
				if(pygame.mouse.get_pressed()[0]):
					w,h = pygame.display.get_surface().get_size()
					cx,cy= pygame.mouse.get_pos()
					cx=   cx - w//2
					cy= h-cy - h//2
					cx/= w
					cy/= h
					view.m= [cx,cy]

			if e.type==TEXTINPUT:
				continue

			if e.type==MOUSEBUTTONDOWN:
				if e.button==1:#LMB
					continue
				if e.button==4:#wheel
					view.z-=1
				if e.button==5:#wheel
					view.z+=1
loop()

rast= glReadPixels(0,0,w,h, GL_RGB,GL_FLOAT)
pygame.display.flip()

print('render t %sms'%((perf_counter()-profile_start)*1000))



profile_start= perf_counter()

print(rast.shape)
rast= rast*(-1+2**8)
rast= rast.astype(np.uint8).flatten()
img= png.Writer(
	size=(w,h),
	bitdepth=8,
	greyscale=False,
	alpha= False,
	compression=4
	)
img.write_array( open('./out.png','wb'), rast )

print('save t %sms'%((perf_counter()-profile_start)*1000))
