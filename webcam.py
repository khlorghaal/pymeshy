import pygame.camera as camera

camera.init()
cam= camera.Camera('/dev/video1')
cam.start()

im= cam.get_image()

print(im)

def exit():
	cam.stop()