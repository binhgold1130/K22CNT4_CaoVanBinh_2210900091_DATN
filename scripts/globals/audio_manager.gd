extends Node

# --- ĐƯỜNG DẪN ĐẾN THƯ MỤC ÂM THANH ---
# (Phải đảm bảo đường dẫn này khớp 100% với tên thư mục của mày)
const MUSIC_PATH = "res://assets/audio/music/"
const SFX_PATH = "res://assets/audio/sfx/"

# --- BIẾN LƯU TRỮ ---
var bgm_player: AudioStreamPlayer
var current_bgm_name: String = ""

func _ready() -> void:
	# Khởi tạo Loa phát nhạc nền (Chỉ cần 1 cái duy nhất cho cả game)
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music" # Cắm vào cột Music trong Bàn Mixer
	add_child(bgm_player)

# ==========================================
# 🎵 PHÁT NHẠC NỀN (BGM)
# ==========================================
func play_bgm(music_name: String) -> void:
	# Nếu đang phát đúng bài này rồi thì thôi, không phát lại từ đầu
	if current_bgm_name == music_name and bgm_player.playing:
		return 

	var stream = load(MUSIC_PATH + music_name)
	if stream:
		bgm_player.stream = stream
		bgm_player.play()
		current_bgm_name = music_name
	else:
		print("[LỖI AUDIO] Không tìm thấy bài nhạc: ", music_name)

func stop_bgm() -> void:
	bgm_player.stop()
	current_bgm_name = ""

# ==========================================
# 💥 PHÁT HIỆU ỨNG ÂM THANH (SFX)
# ==========================================
func play_sfx(sfx_name: String) -> void:
	var stream = load(SFX_PATH + sfx_name)
	if stream:
		# Tuyệt chiêu: Tạo một cái loa nhí mới mỗi khi có tiếng kêu
		# Việc này giúp các âm thanh (như nhiều bước chân) có thể đè lên nhau mượt mà
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.stream = stream
		sfx_player.bus = "SFX" # Cắm vào cột SFX trong Bàn Mixer
		add_child(sfx_player)
		sfx_player.play()
		
		# Tự động vứt cái loa nhí vào sọt rác sau khi phát xong để chống giật lag
		sfx_player.finished.connect(sfx_player.queue_free)
	else:
		print("[LỖI AUDIO] Không tìm thấy hiệu ứng: ", sfx_name)
