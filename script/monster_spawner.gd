extends Node2D

# 몬스터 스폰 관리자 스크립트
# 일정 간격마다 화면 테두리 바깥에서 슬라임을 생성

# 슬라임 씬 프리로드
const SLIME_SCENE: PackedScene = preload("res://scene/slime.tscn")

# 스폰 주기 (초)
const SPAWN_INTERVAL: float = 1.0

# 1회 스폰 시 생성할 슬라임 수
const SPAWN_COUNT: int = 20

# 화면 바깥으로 얼마나 떨어진 곳에서 스폰할지 (픽셀)
const SPAWN_MARGIN: float = 80.0

# 스폰 타이머 누적 변수
var spawn_timer: float = 0.0

# 뷰포트 크기 캐싱
var viewport_size: Vector2 = Vector2.ZERO


func _ready() -> void:
	# 뷰포트 크기를 미리 캐싱
	viewport_size = get_viewport_rect().size


func _process(delta: float) -> void:
	# 스폰 타이머 누적
	spawn_timer += delta
	# 스폰 간격이 지나면 슬라임 웨이브 생성
	if spawn_timer >= SPAWN_INTERVAL:
		# 타이머를 간격만큼 차감 (프레임 보정 유지)
		spawn_timer -= SPAWN_INTERVAL
		# 슬라임 웨이브 스폰 함수 호출
		_spawn_wave()


func _spawn_wave() -> void:
	# 지정된 수만큼 슬라임 생성
	for i in range(SPAWN_COUNT):
		# 슬라임 인스턴스 생성
		var slime: CharacterBody2D = SLIME_SCENE.instantiate()
		# 화면 테두리 바깥 랜덤 위치 계산
		slime.position = _get_random_edge_position()
		# 현재 노드의 자식으로 추가
		add_child(slime)


func _get_random_edge_position() -> Vector2:
	# 상/하/좌/우 4면 중 랜덤으로 한 면 선택 (0=상, 1=하, 2=좌, 3=우)
	var edge: int = randi() % 4
	# 선택된 면에 따라 랜덤 스폰 위치 반환
	match edge:
		0:
			# 상단: x는 화면 너비 범위 내 랜덤, y는 화면 위쪽 바깥
			return Vector2(randf_range(0.0, viewport_size.x), -SPAWN_MARGIN)
		1:
			# 하단: x는 화면 너비 범위 내 랜덤, y는 화면 아래쪽 바깥
			return Vector2(randf_range(0.0, viewport_size.x), viewport_size.y + SPAWN_MARGIN)
		2:
			# 좌측: x는 화면 왼쪽 바깥, y는 화면 높이 범위 내 랜덤
			return Vector2(-SPAWN_MARGIN, randf_range(0.0, viewport_size.y))
		3:
			# 우측: x는 화면 오른쪽 바깥, y는 화면 높이 범위 내 랜덤
			return Vector2(viewport_size.x + SPAWN_MARGIN, randf_range(0.0, viewport_size.y))
	# fallback (도달하지 않음)
	return Vector2.ZERO
