extends Node

# 1. Khai báo đường dẫn cố định đến thư mục chứa tài nguyên âm thanh
const MUSIC_PATH = "res://assets/audio/music/"
const SFX_PATH = "res://assets/audio/sfx/"

# 2. Biến lưu trữ trình phát nhạc nền và tên bài nhạc hiện tại
var bgm_player: AudioStreamPlayer
var current_bgm_name: String = ""

func _ready() -> void:
	# 3. Khởi tạo trình phát nhạc nền duy nhất và gán vào Bus "Music"
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music"
	add_child(bgm_player)

# ==========================================
# 🎵 PHÁT NHẠC NỀN (BGM)
# ==========================================
func play_bgm(music_name: String) -> void:
	# 4. Kiểm tra nếu bài nhạc đang phát trùng với yêu cầu thì không phát lại
	if current_bgm_name == music_name and bgm_player.playing:
		return

	var stream = load(MUSIC_PATH + music_name)
	if stream:
		# 5. Tải và phát bài nhạc nền mới
		bgm_player.stream = stream
		bgm_player.play()
		current_bgm_name = music_name
	else:
		print("[LỖI AUDIO] Không tìm thấy bài nhạc: ", music_name)

func stop_bgm() -> void:
	# 6. Dừng nhạc nền và xóa tên bài nhạc lưu trữ
	bgm_player.stop()
	current_bgm_name = ""

# ==========================================
# 💥 PHÁT HIỆU ỨNG ÂM THANH (SFX)
# ==========================================
func play_sfx(sfx_name: String) -> void:
	var stream = load(SFX_PATH + sfx_name)
	if stream:
		# 7. Khởi tạo trình phát tạm thời cho mỗi hiệu ứng âm thanh
		# Cơ chế này giúp các âm thanh có thể phát chồng lấp lên nhau
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.stream = stream
		sfx_player.bus = "SFX"
		add_child(sfx_player)
		sfx_player.play()
		
		# 8. Tự động giải phóng trình phát tạm thời sau khi âm thanh kết thúc
		sfx_player.finished.connect(sfx_player.queue_free)
	else:
		print("[LỖI AUDIO] Không tìm thấy hiệu ứng: ", sfx_name)
