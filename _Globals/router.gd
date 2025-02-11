extends HttpRouter
class_name LoveRouter

func handle_get(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "You are the best thing that has happened to me.  I love you - River.")
	GameState.to_credits()
