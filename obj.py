from OpenGL.GL import *
from ctypes import c_void_p as voidp
'''
in vec3 position;
in vec2 uv;
in vec3 normal;
'''
def load(file):

	p= []#position
	n= []#normal
	t= []#texcoord
	f= []#indices

	for line in open(file,"r"):
		if line.startswith('#'):
			continue
		l= line.split()
		if not l:
			continue

		{
			'v' : p,
			'vn': n,
			'vt': t,
			'f' : f,
			'o' : [],
			'm' : [],
			's' : []
		}[ l[0] ]+=[ l[1:] ]

	parsevv= lambda vv: [ tuple(float(t) for t in v) for v in vv  ]
	p= parsevv(p)
	t= parsevv(t)
	n= parsevv(n)

	if len(n)==0:
		n= [(0,0,0)]
	if len(t)==0:
		t= [(0,0)]

	import numpy
	narr= lambda l,T: numpy.array(l,dtype=numpy.dtype(T)).flatten()


	#buffers
	p_b=[]
	t_b=[]
	n_b=[]

	for l in f:#face entry; indices; [ face-list [face (vi,ni,ui),..],.. ]
		p_i=[]
		t_i=[]
		n_i=[]
		l= [ _.split('/') for _ in l ]
		for w in l:#face vertex-data 'i/j/k'
			assert(len(l)==4)
			vi= int(w[0])
			ti=0
			if len(w) >= 2 and len(w[1]) > 0:
				ti= int(w[1])
			ni=0
			if len(w) >= 3 and len(w[2]) > 0:
				ni= int(w[2])
			p_i+= [vi-1]
			t_i+= [ti-1]
			n_i+= [ni-1]
		for i in [0,1,2,0,2,3]:#triangulate
			p_b+= p[p_i[i]]
			t_b+= t[t_i[i]]
			n_b+= n[n_i[i]]

	vao= glGenVertexArrays(1)
	glBindVertexArray(vao)


	vbos= glGenBuffers(3)

	glEnableVertexAttribArray(0)
	glBindBuffer(GL_ARRAY_BUFFER,vbos[0])
	glBufferData(GL_ARRAY_BUFFER, narr(p_b,'float32'), GL_STATIC_DRAW)
	glVertexAttribPointer(0, 3, GL_FLOAT,            True, 0, voidp(0))

	glEnableVertexAttribArray(1)
	glBindBuffer(GL_ARRAY_BUFFER,vbos[1])
	glBufferData(GL_ARRAY_BUFFER, narr(t_b,'float32'), GL_STATIC_DRAW)
	glVertexAttribPointer(1, 2, GL_FLOAT, True, 0, voidp(0))

	glEnableVertexAttribArray(2)
	glBindBuffer(GL_ARRAY_BUFFER,vbos[2])
	glBufferData(GL_ARRAY_BUFFER, narr(n_b,'float32'), GL_STATIC_DRAW)
	glVertexAttribPointer(2, 3, GL_FLOAT, True, 0, voidp(0))

	#ebo= glGenBuffers(1)
	#glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ebo)
	#glBufferData(GL_ELEMENT_ARRAY_BUFFER, narr(i,'uint32'), GL_STATIC_DRAW)

	def draw():
		glBindVertexArray(vao)
		#glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ebo)
		#glDrawElements(GL_TRIANGLES,0, GL_UNSIGNED_INT, len(i)//3)
		#glDrawElements(GL_POINTS,0, GL_UNSIGNED_INT, len(i))
		glDrawArrays(GL_TRIANGLES,0, len(p_b))
		#glDrawArrays(GL_TRIANGLES,0, 3)
	return draw