extends Node2D

# 게임 씬 전체를 관리하는 메인 스크립트
# 각 하위 씬(배경, 타워 등)은 자체 스크립트에서 초기화 처리

# UFO 노드 참조
@onready var ufo: Node2D = $UFO
# SkeletonWitch 노드 참조
@onready var skeleton_witch: Node2D = $SkeletonWitch
# 점수 표시 라벨 참조
@onready var score_label: Label = $UILayer/ScoreLabel

# 현재 누적 점수
var score: int = 0


func _ready() -> void:
	# 점수판 초기 텍스트 설정
	score_label.text = "SCORE\n0"


func add_score(amount: int) -> void:
	# 점수 누적 후 라벨 갱신
	score += amount
	score_label.text = "SCORE\n%d" % score


func _unhandled_input(event: InputEvent) -> void:
	# 스페이스바 입력 시 UFO 공격 스킬 테스트 발동 (PC 디버그용)
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		ufo.activate()


func _on_ufo_button_pressed() -> void:
	# UI 버튼 클릭 시 UFO 공격 스킬 발동
	ufo.activate()


func _on_witch_button_pressed() -> void:
	# UI 버튼 클릭 시 Skeleton Witch 광역 스킬 발동
	skeleton_witch.activate()
