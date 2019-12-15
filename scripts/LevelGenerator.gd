extends Node2D
export(PackedScene) var Block
export(PackedScene) var Spike
export(PackedScene) var Bottom
export(PackedScene) var Rave

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var col = 0
var row = 10
var prev = []

func add_block(this_col, h):
    var next = randi()%6
    match next:
        0:
            if randi()% 500-col < 10:
                if this_col[-1] == "b" and col > 20:
                    var s = 0
                    for i in range(4):
                        if prev[-(i+1)][-1] == "s":
                            s += 1
                    if s != 4:
                        var spike = Spike.instance()
                        add_child(spike)
                        spike.position.y = row*50-h*50
                        spike.position.x = col*50
                        this_col.push_back("s")
            else:
                add_block(this_col, h)
        1:    
            if this_col[-1] == "b" and col > 20:
                var s = 0
                for i in range(4):
                    if prev[-(i+1)][-1] == "s":
                        s += 1
                if s != 4:
                    var spike = Spike.instance()
                    add_child(spike)
                    spike.position.y = row*50-h*50
                    spike.position.x = col*50
                    this_col.push_back("s")
        2:
            this_col.push_back("")
            add_block(this_col, h+1)
        3:
            if this_col.size() == 1:
                if prev[-1].size() > 2 and prev[-1][-1] == "b":
                    row -= 1
                else:
                    row += 1
        _:
            var b = 0
            for i in range(4):
                if prev[-(i+1)][-1] == "b":
                    b = max(prev[-(i+1)].size(), b)
            if h < b + 3:
                var block = Block.instance()
                add_child(block)
                block.position.y = row*50-h*50
                block.position.x = col*50
                this_col.push_back("b")
                if h < b + 2:
                    add_block(this_col, h+1)
                    
    if this_col[-1] == "":
        this_col.pop_back()
    return this_col


func make_col():
    var this_col = ["b"]
    var block = Block.instance()
    add_child(block)
    block.position.y = row*50
    block.position.x = col*50
    var bottom = Bottom.instance()
    add_child(bottom)
    bottom.position.y = (row+1)*50
    bottom.position.x = col*50
    
    if prev.size() > 10:
        this_col = add_block(this_col, 1)
        prev.pop_front()

    prev.push_back(this_col)
    if col == 500:
        print("haloo")
        var rave = Rave.instance()
        add_child(rave)
        rave.position.y = row*50
        rave.position.x = col*50
        prev = []
    col += 1

# Called when the node enters the scene tree for the first time.
func _ready():
    for i in range(10):
        var block = Block.instance()
        add_child(block)
        block.position.y = (row-i)*50
        block.position.x = (col-1)*50
    randomize()
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass  




