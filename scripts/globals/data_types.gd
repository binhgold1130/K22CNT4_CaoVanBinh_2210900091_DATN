class_name DataTypes

# 1. Định nghĩa các loại công cụ trong hệ thống
enum Tools {
	None,           # Trạng thái không cầm công cụ
	AxeWood,        # Rìu chặt gỗ
	TillGround,     # Cuốc dùng để cày đất
	WaterCrops,     # Bình tưới nước cho cây
	PlantCorn,      # Hạt giống ngô
	PlantTomato     # Hạt giống cà chua
}

# 2. Định nghĩa các giai đoạn phát triển của cây trồng trong vòng đời sinh trưởng
enum GrowthStates {
	Seed,           # Giai đoạn hạt giống
	Germination,    # Giai đoạn nảy mầm
	Vegetative,     # Giai đoạn phát triển lá và thân
	Reproduction,   # Giai đoạn sinh sản (ra hoa/tạo quả)
	Maturity,       # Giai đoạn cây chín (trưởng thành)
	Harvesting      # Giai đoạn có thể thu hoạch
}
