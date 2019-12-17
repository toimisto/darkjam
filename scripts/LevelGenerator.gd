extends Node2D
export(PackedScene) var Block
export(PackedScene) var Spike
export(PackedScene) var Bottom
export(PackedScene) var Rave
export(PackedScene) var Backdrop

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lvlrng = RandomNumberGenerator.new()
var col = 0
var row = 10
var prev = [["b"],["b"],["b"],["b"],["b"],["b"],["b"]]
var heights = [-10,-10,-10,-10,-10,-10,-10,-10]
var choices = {
    "b": 5,
    "s": 1,
    " ": 2,
    "row": 2
    }
var sumofweights = 0
    

func add_block(this_col, h):
    var next = 0
    var sw = sumofweights * lvlrng.randf()
    for c in choices.keys():
        sw -= choices[c]
        if sw <= 0:
            next = c
            break
    match next:
        "b":
            var b = -1000
            for i in range(4):
                if prev[-(4-i)][-1] == "b":
                    b = max(heights[-(4-i)]-int((i+1)/2), b)
                if prev[-(4-i)][-1] == "s":
                    b += min(b - heights[-(4-i)]-2, 0)
            #print(str(col) + " " + str(row)+ " " + str(h) + " " +str(b))
            #print(this_col)
            if h - row < b + 3:
                var block = Block.instance()
                block.position.y = row*50-h*50
                block.position.x = col*50
                add_child(block)
                this_col.push_back("b")
                if h - row < b + 2:
                    add_block(this_col, h+1)
        "s":    
            if this_col[-1] == "b" and col > 10:
                var s = 0
                for i in range(4):
                    if prev[-(i+1)][-1] == "s":
                        s += 1 + int(prev[-(i+1)].size()/4)
                if s < 4:
                    var spike = Spike.instance()
                    spike.position.y = row*50-h*50
                    spike.position.x = col*50
                    add_child(spike)
                    this_col.push_back("s")
                    if lvlrng.randi()%3==0:
                        this_col.push_back("")
                        this_col.push_back("")
                        this_col.push_back("")
                        add_block(this_col, h+4)
                else:
                    add_block(this_col, h)
        " ":
            this_col.push_back("")
            add_block(this_col, h+1)
        "row":
            if prev[-1].size() > 2 and prev[-1][-1] == "b":
                row -= 1
            else:
                row += 1
            
    while this_col[-1] == "":
        this_col.pop_back()
    heights.push_back(this_col.size() -row)
    return this_col


func make_col(populate=true):
    if col < 500:
        choices["s"] += 0.004
        sumofweights += 0.004
    
    sumofweights -= choices["b"]
    choices["b"] = prev[-1].size() + 4
    sumofweights += choices["b"]
    
    var this_col = ["b"]
    var block = Block.instance()
    block.position.y = row*50
    block.position.x = col*50
    add_child(block)
    var bottom = Bottom.instance()
    bottom.position.y = (row+1)*50
    bottom.position.x = col*50
    add_child(bottom)
    
    if populate:
        this_col = add_block(this_col, 1)
        prev.pop_front()

    prev.push_back(this_col)
    if col == 475:
        var rave = Rave.instance()
        add_child(rave)
        rave.position.y = row*50
        rave.position.x = col*50
        for i in range(18): #make disco floor
            col += 1
            block = Block.instance()
            add_child(block)
            block.position.y = (row)*50
            block.position.x = (col)*50
        
    if col % 5 == 0:
        var backdrop = Backdrop.instance()
        backdrop.position.y = (row-2)*50 - lvlrng.randi()%500
        backdrop.position.x = col*50 + lvlrng.randi()%250
        add_child(backdrop)
            
        
    col += 1

# Called when the node enters the scene tree for the first time.
func _ready():
    for weight in choices.values():
        sumofweights += weight
    for i in range(50):
        for j in range(6):
            var block = Block.instance()
            add_child(block)
            block.position.y = (row+j-i*i/20)*50
            block.position.x = (col-i)*50

    lvlrng.randomize()
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass  




