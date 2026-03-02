extends TextureRect

# 배경 전용 스크립트
# 부모가 Node2D이므로 앵커 시스템이 작동하지 않음
# 뷰포트 크기에 맞게 직접 사이즈를 설정

func _ready() -> void:
	# 뷰포트 전체 크기를 가져옴
	var viewport_size: Vector2 = get_viewport_rect().size
	# 위치를 좌상단(0,0)으로 고정
	position = Vector2.ZERO
	# 뷰포트 전체를 채우도록 크기 설정
	size = viewport_size
