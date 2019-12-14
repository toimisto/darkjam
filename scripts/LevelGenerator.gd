extends Node2D
export(PackedScene) var Block
export(PackedScene) var Spike

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var col = 0
var row = 10


func add_block(prev, this_col, h):
    match randi()%4:
        0:
            var block = Block.instance()
            add_child(block)
            block.position.y = row*50-h*50
            block.position.x = col*50
            this_col.push_back("b")
            add_block(prev, this_col, h+1)
        1:
            if this_col[-1] == "b":
                var spike = Spike.instance()
                add_child(spike)
                spike.position.y = row*50-h*50
                spike.position.x = col*50
                this_col.push_back("s")
        2:
            this_col.push_back("")
            add_block(prev, this_col, h+1)
        3:
            pass
    if this_col[-1] == "":
        this_col.pop_back()
    return this_col


func make_col(prev):
    var this_col = ["b"]
    var block = Block.instance()
    add_child(block)
    block.position.y = row*50
    block.position.x = col*50
    
    if prev.size() > 10:
        this_col = add_block(prev, this_col, 1)
        prev.pop_front()

    prev.push_back(this_col)

    col += 1
    return prev

# Called when the node enters the scene tree for the first time.
func _ready():
    var prev = []
    for i in range(50):
        prev = make_col(prev)
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
