@tool
extends SubViewport

@export_tool_button("Take Photo") var button = take_photo
@export var file_name : String = "thumbnail.png"

func take_photo():
	print(self.get_viewport().get_texture().get_image().save_png("./thumbnails/results/" + file_name))
	
