extends Node

var score := 0
var highscore := 0


func add_score(amount):
	score += amount

	if score > highscore:
		highscore = score


func reset_score():
	score = 0
