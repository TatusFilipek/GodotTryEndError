extends Node

const PLAYER = preload("uid://b5uy0wyxkan33")

var peer := ENetMultiplayerPeer.new()

var port = 42069
var ip = "localhost"

func start_server() -> void:
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

func join_server() -> void:
	peer.create_client(ip, port)
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.multiplayer_peer = peer

func on_connected_to_server() -> void:
	add_player(multiplayer.get_unique_id())

func add_player(peer_id: int) -> void:
	if peer_id == 1: return
	
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	get_tree().current_scene.add_child(new_player, true)

func remove_player(peer_id: int) -> void:
	if peer_id == 1:
		leave_server()
	
	var players: Array[Node] = get_tree().get_nodes_in_group('Players')
	var player_to_remove = players.find_custom(func(item: Node): return item.name == str(peer_id))
	
	if player_to_remove != -1:
		players[player_to_remove].queue_free()

func leave_server() -> void:
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	
	clean_up_signals()
	
	get_tree().reload_current_scene()

func clean_up_signals() -> void:
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(remove_player)
	multiplayer.connected_to_server.disconnect(on_connected_to_server)
