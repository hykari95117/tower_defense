extends Node2D

# UFO 공격 스킬 스크립트
# 화면 밖에서 등장 -> 시계 방향으로 순환 이동 -> 화면 밖으로 퇴장
# 이동 중 빔 영역에 닿은 몬스터는 즉시 제거

# 화면 밖 시작/종료 위치 (좌측 상단 바깥)
const OFF_SCREEN_POS: Vector2 = Vector2(-400, -400)

# 각 구간 이동 소요 시간 (초)
const MOVE_DURATION: float = 0.9

# 시계 위치 계산용 각도 (라디안)
# 11시 = 330도, 1시 = 30도, 5시 = 150도, 7시 = 210도
const DEG_30: float = deg_to_rad(30.0)
const DEG_60: float = deg_to_rad(60.0)

# 빔 Area2D 참조
@onready var beam_area: Area2D = $BeamArea

# 현재 활성 Tween 참조 (중복 방지 및 정리용)
var _active_tween: Tween = null


func _ready() -> void:
	# 초기 상태: 화면 밖에 숨김
	position = OFF_SCREEN_POS
	# 비활성 상태로 시작
	visible = false
	# 빔 충돌 시그널 연결
	beam_area.body_entered.connect(_on_beam_body_entered)


func activate() -> void:
	# UFO 공격 시퀀스 시작
	# 이미 보이는 상태면 중복 실행 방지
	if visible:
		return
	# 기존 Tween이 남아있으면 정리
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	# 화면에 표시
	visible = true
	# 시작 위치로 이동
	position = OFF_SCREEN_POS
	# 시계 방향 경유지 좌표 계산
	var waypoints: Array[Vector2] = _calculate_waypoints()
	# Tween 생성 및 시퀀스 구성
	var tween: Tween = create_tween()
	# 활성 Tween 참조 저장
	_active_tween = tween
	# 등장: 화면 밖 -> 11시 방향
	tween.tween_property(self, "position", waypoints[0], MOVE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# 11시 -> 1시 방향 이동
	tween.tween_property(self, "position", waypoints[1], MOVE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# 1시 -> 5시 방향 이동
	tween.tween_property(self, "position", waypoints[2], MOVE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# 5시 -> 7시 방향 이동
	tween.tween_property(self, "position", waypoints[3], MOVE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# 7시 -> 11시 방향 복귀
	tween.tween_property(self, "position", waypoints[0], MOVE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# 퇴장: 11시 -> 화면 밖으로 사라짐
	tween.tween_property(self, "position", OFF_SCREEN_POS, MOVE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	# Tween 완료 시 비활성화 콜백
	tween.tween_callback(_on_sequence_finished)


func _calculate_waypoints() -> Array[Vector2]:
	# 뷰포트 크기 기반 동적 좌표 계산
	var viewport_size: Vector2 = get_viewport_rect().size
	# 화면 중앙 좌표
	var center: Vector2 = viewport_size / 2
	# 11시 방향: 좌상단 — 화면 테두리 안쪽 배치
	var pos_11: Vector2 = Vector2(center.x * 0.25, center.y * 0.15)
	# 1시 방향: 우상단 — 화면 테두리 안쪽 배치
	var pos_1: Vector2 = Vector2(center.x * 1.75, center.y * 0.15)
	# 5시 방향: 우하단 — 빔이 화면 밖으로 잘리지 않도록 Y를 1.5로 제한
	var pos_5: Vector2 = Vector2(center.x * 1.85, center.y * 1.5)
	# 7시 방향: 좌하단 — 빔이 화면 밖으로 잘리지 않도록 Y를 1.5로 제한
	var pos_7: Vector2 = Vector2(center.x * 0.15, center.y * 1.5)
	# 시계 방향 순서로 배열 반환
	return [pos_11, pos_1, pos_5, pos_7]


func _on_beam_body_entered(body: Node2D) -> void:
	# 빔에 닿은 오브젝트가 몬스터 그룹인지 확인
	if body.is_in_group("monster"):
		# 몬스터 즉시 제거
		body.queue_free()


func _on_sequence_finished() -> void:
	# 시퀀스 완료 후 비활성화
	visible = false
	# 화면 밖 위치로 복귀
	position = OFF_SCREEN_POS
