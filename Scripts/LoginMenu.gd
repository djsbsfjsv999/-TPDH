extends Control
var IsSignUp = true
var AttachedStatsID = 'AttachedStatsID'
var IsAdmin = false
var RightCode = '0000'

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded) 
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded) 
	Firebase.Auth.login_failed.connect(on_login_failed) 
	Firebase.Auth.signup_failed.connect(on_signup_failed) 
	$AnimationPlayer.play("MovingDown")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sign_up_button_button_down():
	if IsSignUp == false:
		$AnimationPlayer.play_backwards("RegLog")
		IsSignUp = true



func _on_log_in_button_button_down():
	if IsSignUp == true:
		$AnimationPlayer.play("RegLog")
		IsSignUp = false

func on_login_succeeded(auth):
	print(auth)
	$Panel/Label.text = 'успешный вход!'
	Global.Gmail = $Panel/Email.text
	await get_tree().create_timer(1).timeout
	

	var document = await Firebase.Firestore.collection(AttachedStatsID).get_doc(str(Global.Gmail))
	var StringData = document.to_string().split('\n')
	print(StringData)
	StringData = str(StringData[1]).erase(0,len(str(StringData[1])) - 10)
	if StringData.count('true') == 1:
		Global.IsAdmin = true
		get_tree().change_scene_to_file('res://Scenes/MainMenuAdmin.tscn')
		
	else:
		Global.IsAdmin = false
		get_tree().change_scene_to_file('res://Scenes/MainMenu.tscn')

	
	#print(Global.IsAdmin)
	#print()
	



func save_data():
	var auth = Firebase.Auth.auth 
	if auth.localid:
		var AttachedCollection: FirestoreCollection = Firebase.Firestore.collection(AttachedStatsID)
		var AttachedData: Dictionary = {
			'IsAdmin': IsAdmin,
			'PartyCode': '0000'
		}
		AttachedCollection.add(Global.Gmail, AttachedData)

func on_signup_succeeded(auth):
	print(auth)
	$Panel/Label.text = 'успешная регистрация!'
	await get_tree().create_timer(1).timeout
	Global.Gmail = $Panel/Email.text
	
	save_data()
	if Global.IsAdmin == true:
		get_tree().change_scene_to_file('res://Scenes/MainMenuAdmin.tscn')
	else:
		get_tree().change_scene_to_file('res://Scenes/MainMenu.tscn')
	
func on_login_failed(error_code, message):
	print(error_code)
	print(message)
	$Panel/Label.text = 'Fail:' + str(message)
func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	$Panel/Label.text = 'Fail:' + str(message)


func _on_sumbit_button_down():
	if IsSignUp == true and $Panel/Code.text == '':
			var email = $Panel/Email.text 
			var password = $Panel/Password.text
			IsAdmin = false
			
			Firebase.Auth.signup_with_email_and_password(email, password)
			$Panel/Label.text = 'регистрируемся...'
			
	elif IsSignUp == true and $Panel/Code.text == RightCode:
			var email = $Panel/Email.text 
			var password = $Panel/Password.text
			IsAdmin = true
			Global.IsAdmin = true
			
			Firebase.Auth.signup_with_email_and_password(email, password)
			$Panel/Label.text = 'регистрируемся...'
			
	elif IsSignUp == true and $Panel/Code.text != RightCode:
		$Panel/Label.text = 'некорректный код!'
	else:
			var email = $Panel/Email.text 
			var password = $Panel/Password.text
			Firebase.Auth.login_with_email_and_password(email, password)
			$Panel/Label.text = 'входим в аккаунт...'
