extends CharacterBody2D

# 슬라임 몬스터 전용 스크립트
# 화면 바깥에서 스폰되어 화면 중앙(타워)을 향해 직선 이동

# 기본 이동 속도 (픽셀/초)
const BASE_SPEED: float = 120.0

# 속도 랜덤 변동 범위 (기본 속도의 -30% ~ +30%)
const SPEED_VARIATION: float = 0.3

# 슬라임 체력 (flame_shot 2회 피격 시 사망)
var hp: int = 2

# 실제 적용되는 이동 속도 (스폰 시 랜덤 결정)
var move_speed: float = 0.0

# 이동 방향 벡터 (정규화)
var move_direction: Vector2 = Vector2.ZERO

# 타워(화면 중앙) 위치 캐싱
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# 몬스터 그룹에 등록 (투사체 충돌 판정용)
	add_to_group("monster")
	# 뷰포트 중앙을 타겟 위치로 설정
	target_position = get_viewport_rect().size / 2
	# 스폰 위치에서 타겟까지의 방향 벡터 계산
	move_direction = (target_position - position).normalized()
	# 기본 속도에 랜덤 변동 적용 (-30% ~ +30%)
	move_speed = BASE_SPEED * (1.0 + randf_range(-SPEED_VARIATION, SPEED_VARIATION))


func _physics_process(_delta: float) -> void:
	# 방향 * 속도로 velocity 설정
	velocity = move_direction * move_speed
	# CharacterBody2D 내장 이동 함수 호출
	move_and_slide()


func take_damage() -> void:
	# 피격 시 체력 1 감소
	hp -= 1
	# 체력이 0 이하이면 슬라임 삭제
	if hp <= 0:
		queue_free()
