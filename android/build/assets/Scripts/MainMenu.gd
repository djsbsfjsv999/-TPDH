extends Control
var AttachedStatsID = 'AttachedStatsID'
var teamID = 000

func _ready():
	save_data()

func save_data():
	var auth = Firebase.Auth.auth 
	if auth.localid:
		var AttachedCollection: FirestoreCollection = Firebase.Firestore.collection(AttachedStatsID)
		var AttachedData: Dictionary = {
			'IsAdmin': false,
			'TeamID': teamID
		}
		AttachedCollection.add(Global.Gmail, AttachedData)
