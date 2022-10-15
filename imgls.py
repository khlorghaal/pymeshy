import numpy as np
import png
#import exr
from time import *

ANIM= 0
time= 0

img= None
try:
	img= png.Reader('img.png').read()
	w= img.width
	h= img.height
	rast= img.raster.flatten()
	assert(len(rast)==w*h*4)
except:
	w= 2560
	h= 1440
	#w,h= (9075,6201)
	rast= np.zeros(w*h*4)

import pygame
from pygame.locals import *

def chexit():#check exit status
	for event in pygame.event.get():
			if event.type == pygame.KEYDOWN and event.key==pygame.K_SPACE:
				exit()

import ctypes as ct
from OpenGL.GL import *
from OpenGL.GL import shaders
from OpenGL.GL.EXT.texture_filter_anisotropic import *

pygame.init()
resolution= (w,h)
pygame.display.set_mode(resolution, DOUBLEBUF | OPENGL)
pygame.display.set_caption('____________________________')

progs= []
def loadprogs():
	with open("imgls.comp.glsl") as f:
		csh_src= f.read()
	def prog(m):
		try:
			csh_src_p= ''.join([
				'#version 450\n',
				*['#define %s 1\n'%d for d in m],
				'#line 1\n',
				csh_src
			])
			csh_sh= shaders.compileShader(csh_src_p, GL_COMPUTE_SHADER)
			return (shaders.compileProgram(csh_sh),m)
		except Exception as e:
			print('\nSHADERROR\n')
			e= str(e)
			e= e.replace('\\\\n','\n')
			e= e.replace(  '\\n','\n')
			e= e.replace(  '\\t','\t')
			e= e.replace(  '\\t','\t')
			e= e.replace(  '\\','')
			e= e.replace('\\\\','')#fuck
			import re
			e= re.sub(r'\(([0-9]+)\)', r'\nFile "imgls.comp.glsl", line \1', e)
			#sublime default error regex
			print(e)
			exit()

	#progs= list(map(prog,[
	#	['STAGE_GEOMAG'],
	#	*([['STAGE_FLARE']]*5),
	#	['STAGE_TONEMAP']
	#	]))
	global progs
	progs= [prog(['FORWARD'])]

textures= glGenTextures(3)
_pingpong= textures[:2]
tex_basis= textures[ 2]
for i,pp in enumerate(textures):
	glBindTexture(GL_TEXTURE_2D,pp)
	MIPS= 2
	glTexStorage2D(GL_TEXTURE_2D, MIPS, GL_RGBA32F, w,h)#memory uninitialized, inits mipmap level range
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_ANISOTROPY_EXT, 4)


T= 4 if ANIM else 32;#number of tile divisions
LS= 4;#kernel local_size
wg= ( w//(LS*T)+1, h//(LS*T)+1, 1)

SS= 8 #supersample width

profile_start= perf_counter()

def render():
	loadprogs()#recompile every frame lmao
	for ty in range(T):
		for tx in range(T):

			for p in progs:
				(p,args)= p
				glUseProgram(p)
				glUniform2f(0,w,h)
				glUniform2i(1,w,h)
				glUniform2i(2,tx*w//T,ty*h//T)
				glUniform1f(4, time)
				if ANIM:
					glUniform1i(3, 1)#SS
					glUniform1i(5,1<<10)#dist
					glUniform1i(6,11)#bounces
				else:
					glUniform1i(3, SS)
					glUniform1i(5,1<<17)
					glUniform1i(6,28)

				if 'STAGE_GEOMAG' in args:
					glBindImageTexture(0,tex_basis, 0,False,0, GL_WRITE_ONLY, GL_RGBA32F)
				else:
					#_pingpong= _pingpong[::-1]

					#glActiveTexture(GL_TEXTURE0+0)
					#glBindTexture(GL_TEXTURE_2D,_pingpong[0])
					#glGenerateMipmap(GL_TEXTURE_2D)

					#glActiveTexture(GL_TEXTURE0+1)
					#glBindTexture(GL_TEXTURE_2D,tex_basis)

					glBindImageTexture(0,_pingpong[1], 0,False,0, GL_WRITE_ONLY, GL_RGBA32F)

				glDispatchCompute(*wg)
				glMemoryBarrier( GL_SHADER_IMAGE_ACCESS_BARRIER_BIT )

			fb= glGenFramebuffers(1)
			glBindFramebuffer(GL_READ_FRAMEBUFFER, fb)
			glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0)
			glFramebufferTexture2D(GL_READ_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,_pingpong[1], 0)
			glBlitFramebuffer(0,0,w,h,0,0,w,h,GL_COLOR_BUFFER_BIT, GL_NEAREST)
			pygame.display.flip()
			sleep(1./120)
			chexit()

if ANIM:
	while 1:
		render()
		time+=1
		sleep(1./35)
		chexit()
else:
	render()

del rast
rast= glReadPixels(0,0,w,h, GL_RGB,GL_FLOAT)

pygame.display.flip()

print('render time %sms'%((perf_counter()-profile_start)*1000))

profile_start= perf_counter()

print(rast.shape)
rast= rast*(-1+2**16)
rast= rast.astype(np.uint16).flatten()
img= png.Writer(
	size=(w,h),
	bitdepth=16,
	greyscale=False,
	alpha= False,
	compression=4
	)

img.write_array( open('./out.png','wb'), rast )

print('save time %sms'%((perf_counter()-profile_start)*1000))

while(1):
	chexit()
	sleep(.250)