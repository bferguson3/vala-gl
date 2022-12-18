// just a test!
uses GLFW 
uses GL

init
	glinit()

	var win = new Window(640, 400, "HW", null, null)
	win.make_context_current()

	while !win.should_close
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
		win.swap_buffers()
		poll_events()

	glterminate()
