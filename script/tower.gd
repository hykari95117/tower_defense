extends Sprite2D

# 타워 전용 스크립트
# 타워를 화면 정중앙에 배치하고, 기본 공격(투사체 발사)을 수행

# 투사체 씬을 미리 로드 (인스턴스 생성용)
const PROJECTILE_SCENE: PackedScene = preload("res://scene/flame_shot.tscn")

# 초당 발사 횟수
const FIRE_RATE: float = 4.0

# 발사 간격을 누적할 타이머 변수
var fire_timer: float = 0.0

# 발사 간격 (초 단위)
var fire_interval: float = 1.0 / FIRE_RATE


func _ready() -> void:
	# 뷰포트 크기를 가져와서 정중앙 좌표를 계산
	position = get_viewport_rect().size / 2


func _process(delta: float) -> void:
	# 발사 타이머 누적
	fire_timer += delta
	# 발사 간격이 지나면 투사체 발사
	if fire_timer >= fire_interval:
		# 타이머를 간격만큼 차감 (프레임 보정 유지)
		fire_timer -= fire_interval
		# 투사체 발사 함수 호출
		_fire_projectile()


func _fire_projectile() -> void:
	# 투사체 씬 인스턴스 생성
	var projectile: Area2D = PROJECTILE_SCENE.instantiate()
	# 투사체 시작 위치를 타워 중심으로 설정
	projectile.position = position
	# 360도 중 랜덤 각도 생성 (라디안)
	var random_angle: float = randf() * TAU
	# 각도를 방향 벡터로 변환하여 투사체에 전달
	projectile.direction = Vector2(cos(random_angle), sin(random_angle))
	# 투사체 스프라이트를 발사 방향으로 회전
	projectile.rotation = random_angle
	# 부모 노드(Game)에 투사체를 자식으로 추가
	get_parent().add_child(projectile)
