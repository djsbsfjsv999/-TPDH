extends Control
var AttachedStatsID = 'AttachedStatsID'
var teamID = '0000'
var isread = false

var PostCollectionID = 'Posts'
var PostDocumentName = 'PostDocument'
func _ready():
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

		$PostsMain/PanelPost/PanelPrizmarine/PostNameLabel.text = 'Сообщение от админа ' + str(PostNameFinal)
		$PostsMain/PanelPost/PostLabel.text = PostDataFinal
		$PostsMain/SyncingPanel.hide()


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
	$TeamsMain.hide()
	$TestMain.hide()
	$VotingMain.hide()
	$ReaderMain.hide()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("PostsAppearing")
	ReloadPost()


func _on_party_button_up():
	$PostsMain.hide()
	$TestMain.hide()
	$TeamsMain.show()
	$VotingMain.hide()
	$ReaderMain.hide()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("TeamsAppearing")
	$TeamsMain/SyncingPanel.show()
	var document = await Firebase.Firestore.collection(AttachedStatsID).get_doc(str(Global.Gmail))
	var StringData = document.to_string().split('\n')
	#StringData = str(StringData[1]).erase(0,37)
	#StringData = StringData.erase(len(StringData) -6, 6)
	var MyPartyCode = str(StringData[1])
	#MyPartyCode = MyPartyCode.erase(len(MyPartyCode) - 5, 5)

	print(MyPartyCode)
	MyPartyCode = MyPartyCode.erase(0, MyPartyCode.find('stringValue') + 15)
	MyPartyCode = MyPartyCode.erase(4, len(MyPartyCode) -4)
	MyPartyCode = MyPartyCode
	
	if MyPartyCode == '0000':
		$TeamsMain/TextTeam.text = 'Вы не состоите в команде'
	else:
		$TeamsMain/PartyCodeLine.text = str(MyPartyCode)
	$TeamsMain/SyncingPanel.hide()


func _on_test_button_up():
	$PostsMain.hide()
	$TestMain.show()
	$TeamsMain.hide()
	$VotingMain.hide()
	$ReaderMain.hide()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("TestAppearing")


func _on_voting_button_up():
	$PostsMain.hide()
	$TestMain.hide()
	$TeamsMain.hide()
	$VotingMain.show()
	$ReaderMain.hide()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("VotingAppearing")


func _on_reader_button_up():
	$PostsMain.hide()
	$TestMain.hide()
	$TeamsMain.hide()
	$VotingMain.hide()
	$ReaderMain.show()
	$AnalyticsMain.hide()
	CloseMenu()
	$AnimationPlayer2.play("ReaderAppearing")


func _on_analytics_button_up():
	$PostsMain.hide()
	$TestMain.hide()
	$TeamsMain.hide()
	$VotingMain.hide()
	$ReaderMain.hide()
	$AnalyticsMain.show()
	CloseMenu()
	$AnimationPlayer2.play("AnalyticsAppearing")


func _on_settings_button_up():
	CloseMenu()


func _on_go_link_button_down():
	OS.shell_open('https://forms.gle/w1BWDLMgvfQHHaVQ9')


func _on_button_pressed():
	isread = true



func _input(event):
	if event is InputEventScreenDrag:
		if isread == true:
			$ReaderMain/ReaderUp.global_position.y += event.relative.y
		if $ReaderMain/ReaderUp.global_position.y > 10:
			$ReaderMain/ReaderUp.global_position.y = 10


func _on_teams_sumbit_button_down():
	var NewCode = $TeamsMain/PartyCodeLine.text
	if len(NewCode) == 4:
		var auth = Firebase.Auth.auth 
		if auth.localid:
			$TeamsMain/SyncingPanel.show()
			var document = await Firebase.Firestore.collection(AttachedStatsID).get_doc(str(Global.Gmail))
			document.add_or_update_field('PartyCode', $TeamsMain/PartyCodeLine.text)
			await Firebase.Firestore.collection(AttachedStatsID).update(document)
			$TeamsMain/TextTeam.text = 'Команда сменена!'
			$TeamsMain/SyncingPanel.hide()
