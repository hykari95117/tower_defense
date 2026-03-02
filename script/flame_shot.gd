extends Area2D

# 투사체 전용 스크립트
# 발사 방향으로 직진하며, 화면 밖을 벗어나면 자동 삭제

# 투사체 이동 속도 (픽셀/초)
const SPEED: float = 600.0

# 화면 밖 판정용 여유 마진 (픽셀)
const MARGIN: float = 50.0

# 투사체가 날아갈 방향 벡터 (정규화된 상태로 사용)
var direction: Vector2 = Vector2.ZERO

# 뷰포트 크기 캐싱 (매 프레임 호출 방지)
var viewport_size: Vector2 = Vector2.ZERO


func _ready() -> void:
	# 뷰포트 크기를 미리 캐싱
	viewport_size = get_viewport_rect().size


func _process(delta: float) -> void:
	# 방향 벡터 * 속도 * 델타로 매 프레임 이동
	position += direction * SPEED * delta
	# 화면 밖 벗어남 여부 체크 후 삭제
	_check_out_of_screen()


func _check_out_of_screen() -> void:
	# 마진을 포함하여 화면 밖인지 판정
	if position.x < -MARGIN or position.x > viewport_size.x + MARGIN:
		# 좌우 화면 밖이면 삭제
		queue_free()
	elif position.y < -MARGIN or position.y > viewport_size.y + MARGIN:
		# 상하 화면 밖이면 삭제
		queue_free()
