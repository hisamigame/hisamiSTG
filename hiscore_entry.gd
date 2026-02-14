extends HSplitContainer
class_name HiScoreEntry

func set_AAA(t):
	$Name.text = t

func set_score(n):
	$Score.text = str(int(n))

func turn_yellow():
	modulate = Color.YELLOW
	
func turn_normal():
	modulate = Color.WHITE
