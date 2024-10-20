extends Control
var AttachedStatsID = 'AttachedStatsID'
var PostCollectionID = 'Posts'
var PostDocumentName = 'PostDocument'
var teamID = 000
var isread = false

func _ready():
	#$LeftMenuPanel.position.x -= DisplayServer.window_get_size().x
	#print(DisplayServer.window_get_size().x)
	$AnimationPlayer.play("RESET")
	ReloadPost()

func ReloadPost():
	
	var auth = Firebase.Auth.auth 
	if auth.localid:
		$PostsMain/SyncingPanel.show()
		var PostCollection: FirestoreCollection = Firebase.Firestore.collection(PostCollectionID)
		var PostDocument = await PostCollection.get_doc(PostDocumentName)
		#print(PostDocument)
		var PostDataFinal = PostDocument.to_string().split('\n')
		PostDataFinal = str(PostDataFinal[1]).erase(0,34)
		PostDataFinal = PostDataFinal.erase(len(PostDataFinal)-7,7)
		
		var PostNameFinal = PostDocument.to_string().split('\n')
		PostNameFinal = str(PostNameFinal[2]).erase(0,13)
		PostNameFinal = PostNameFinal.erase(10, 17)

		$PostsMain/PanelPost/PanelPrizmarine/LabelPost.text = 'Сообщение от админа ' + str(PostNameFinal)
		$PostsMain/PanelPost/LabelPost.text = PostDataFinal
		$PostsMain/SyncingPanel.hide()
func save_data():
	var auth = Firebase.Auth.auth 
	if auth.localid:
		var AttachedCollection: FirestoreCollection = Firebase.Firestore.collection(AttachedStatsID)
		var AttachedData: Dictionary = {
			'IsAdmin': false,
			'TeamID': teamID
		}
		AttachedCollection.add(Global.Gmail, AttachedData)

func update_post():
	var auth = Firebase.Auth.auth 
	if auth.localid:
		
		var PostCollection: FirestoreCollection = Firebase.Firestore.collection(PostCollectionID)
		var PostData : Dictionary = {
			"Post" : str($PostsMain/PanelPost/LabelPost.text)
		}
		var PostDocument = await PostCollection.get_doc(PostDocumentName)
		#var PostDocument = await PostCollection.add(PostDocumentName, PostData)
		PostDocument.add_or_update_field("Post", str($PostsMain/PanelPost/LabelPost.text))
		await PostCollection.update(PostDocument)
		
		#PostCollection.add(PostDocumentName, PostData)

func _on_settings_button_button_down():
	$AnimationPlayer.play("LeftPanel")
	$LeftMenuPanel/LeftMenu/CloseMenu.show()



func _on_close_menu_button_down():
	CloseMenu()

func CloseMenu():
	$AnimationPlayer.play_backwards("LeftPanel")
	$LeftMenuPanel/LeftMenu/CloseMenu.hide()

func _on_posts_button_up():
	
	$PostsMain.show()
	$TestMain.hide()
	$VotingMain.hide()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("PostsAppearing")
	ReloadPost()


func _on_test_button_up():
	$PostsMain.hide()
	$TestMain.show()
	$VotingMain.hide()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("TestAppearing")


func _on_voting_button_up():
	$PostsMain.hide()
	$TestMain.hide()
	$VotingMain.show()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("VotingAppearing")



func _on_analytics_button_up():
	$PostsMain.hide()
	$TestMain.hide()
	$VotingMain.hide()
	$AnalyticsMain.show()
	CloseMenu()
	$AnimationPlayer2.play("AnalyticsAppearing")


func _on_settings_button_up():
	CloseMenu()


func _on_go_link_button_down():
	OS.shell_open('https://docs.google.com/forms/d/1qxIm5UpbW1IgmS8tYEgwJ7L16Ex2WrERjopSIDfX-MI/edit')


func _on_sumbit_button_down():
	update_post()
