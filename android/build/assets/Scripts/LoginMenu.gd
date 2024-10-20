extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded) 
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded) 
	Firebase.Auth.login_failed.connect(on_login_failed) 
	Firebase.Auth.signup_failed.connect(on_signup_failed) 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sign_up_button_button_down():
	var email = $Panel/Email.text 
	var password = $Panel/Password.text
	Firebase.Auth.signup_with_email_and_password(email, password)
	$Panel/Label.text = 'signing up...'


func _on_log_in_button_button_down():
	var email = $Panel/Email.text 
	var password = $Panel/Password.text
	Firebase.Auth.login_with_email_and_password(email, password)
	$Panel/Label.text = 'logging in...'

func on_login_succeeded(auth):
	print(auth)
	$Panel/Label.text = 'login success'
	await get_tree().create_timer(1).timeout
	Global.Gmail = $Panel/Email.text
	get_tree().change_scene_to_file('res://Scenes/MainMenu.tscn')
	
func on_signup_succeeded(auth):
	print(auth)
	$Panel/Label.text = 'signup success'
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file('res://Scenes/MainMenu.tscn')
	
func on_login_failed(error_code, message):
	print(error_code)
	print(message)
	$Panel/Label.text = 'Fail:' + str(message)
func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	$Panel/Label.text = 'Fail:' + str(message)
