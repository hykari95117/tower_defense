extends Node2D

# Skeleton Witch 광역 공격 스킬 스크립트
# 화면 중앙에 등장 -> 스프라이트 애니메이션 재생 -> 모든 몬스터 제거 -> 퇴장

# 페이드 인/아웃 소요 시간 (초)
const FADE_DURATION: float = 1.5

# 스프라이트 시트 총 프레임 수
const TOTAL_FRAMES: int = 61

# 스프라이트 애니메이션 FPS (61프레임 / 약 4초)
const ANIM_FPS: float = 15.0

# AnimatedSprite2D 대신 Sprite2D를 사용 (스프라이트 시트 직접 제어)
@onready var sprite: Sprite2D = $Sprite2D

# 현재 활성 Tween 참조 (중복 방지)
var _active_tween: Tween = null

# 애니메이션 재생 중 여부
var _is_playing: bool = false

# 현재 프레임 인덱스
var _current_frame: int = 0

# 프레임 타이머 누적값
var _frame_timer: float = 0.0


func _ready() -> void:
	# 초기 상태: 비활성
	visible = false
	# 투명도 0으로 시작
	modulate.a = 0.0


func _process(delta: float) -> void:
	# 애니메이션 재생 중이 아니면 처리 안 함
	if not _is_playing:
		return
	# 프레임 타이머 누적
	_frame_timer += delta
	# 프레임 간격 계산 (1초 / FPS)
	var frame_interval: float = 1.0 / ANIM_FPS
	# 타이머가 프레임 간격을 넘었으면 다음 프레임으로
	if _frame_timer >= frame_interval:
		_frame_timer -= frame_interval
		_current_frame += 1
		# 모든 프레임 재생 완료 체크
		if _current_frame >= TOTAL_FRAMES:
			# 애니메이션 재생 종료
			_is_playing = false
			# 페이드 아웃 시작
			_start_fade_out()
			return
		# 스프라이트 프레임 갱신
		sprite.frame = _current_frame


func activate() -> void:
	# 이미 활성 상태면 중복 실행 방지
	if visible:
		return
	# 기존 Tween 정리
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	# 화면 중앙 위치 계산
	var viewport_size: Vector2 = get_viewport_rect().size
	position = viewport_size / 2
	# 스프라이트 크기를 화면 전체에 맞게 스케일 계산 (8x8 그리드 기준 프레임 크기)
	var frame_size: Vector2 = Vector2(sprite.texture.get_width() / 8.0, sprite.texture.get_height() / 8.0)
	sprite.scale = (viewport_size * 0.5) / frame_size
	# 투명도 초기화
	modulate.a = 0.0
	# 프레임 초기화
	_current_frame = 0
	_frame_timer = 0.0
	sprite.frame = 0
	# 화면에 표시
	visible = true
	# 모든 몬스터 즉시 제거
	_kill_all_monsters()
	# 페이드 인 시작
	_start_fade_in()


func _kill_all_monsters() -> void:
	# "monster" 그룹에 속한 모든 노드 목록 가져오기
	var monsters = get_tree().get_nodes_in_group("monster")
	# 제거 전에 마리 수 * 10점을 한 번에 점수 반영
	var game_node = get_tree().get_root().get_node("Game")
	game_node.add_score(monsters.size() * 10)
	# 모든 몬스터 즉시 제거
	monsters.map(func(m): m.queue_free())


func _start_fade_in() -> void:
	# 페이드 인 Tween 생성
	var tween: Tween = create_tween()
	_active_tween = tween
	# 투명도 0 -> 1 전환 (1.5초)
	tween.tween_property(self, "modulate:a", 1.0, FADE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# 페이드 인 완료 후 스프라이트 애니메이션 시작
	tween.tween_callback(_start_animation)


func _start_animation() -> void:
	# 스프라이트 프레임 애니메이션 재생 시작
	_is_playing = true
	_current_frame = 0
	_frame_timer = 0.0
	sprite.frame = 0


func _start_fade_out() -> void:
	# 페이드 아웃 Tween 생성
	var tween: Tween = create_tween()
	_active_tween = tween
	# 투명도 1 -> 0 전환 (1.5초)
	tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# 페이드 아웃 완료 후 비활성화
	tween.tween_callback(_on_sequence_finished)


func _on_sequence_finished() -> void:
	# 시퀀스 완료 후 비활성화
	visible = false
	# 애니메이션 상태 초기화
	_is_playing = false
