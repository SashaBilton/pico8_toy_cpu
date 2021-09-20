pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

cmp_flag = false
reg_a = 0
reg_b = 0
mem_size = 50
stack = {}
print_buffer = "toy cpu emul "
program = { 
            "ld","a","100",     --1
            "inc","a",          --4
            "ld", "&50", "a",   --6
            "inc","a",          --9
            "jmp", ".output",   --11
            "cp","102",         --13
            "jpc", "&4",        --15
            ".end" 
        }
pc = 1

print_buffer_mem = "&50"

function _init()
    for pad=#program+1,mem_size do
        add(program,0)
    end
end

function parse_next()

    _draw()
    cmd = program[pc]
    --print_buffer = cmd
    if (sub(cmd, 1, 1) == ".") then
        if (cmd == ".end") then 
            stop("stopped.")
        end
    end

    if (cmd == "ld") then
        target = program[pc+1]
        value = program[pc+2]
        pc += 2
        load(target, value)
    elseif (cmd == "inc") then
        target = program[pc+1]
        pc += 1

        increment(target, value)
    elseif (cmd == "jmp") then
        target = program[pc+1]
        pc += 1
        add(stack, pc)
        jump(target)
    elseif (cmd == "cp") then
        target = program[pc+1]
        pc += 1
        compare(reg_a, target)
        
    elseif (cmd == "jpc") then
        target = program[pc+1]
        pc += 1
        jump_compare(target)
    end
    pc+= 1
    if (pc > mem_size) then
        pc = 1
    end
end

function get_direct(loc)
    local mem_loc = sub(loc,2)
    return program[mem_loc]
end

function set_direct(loc, value)
    local mem_loc = sub(loc,2)
    program[mem_loc] = value
end


function load(target, value)
    
    local actual_value = 0
    if (sub(value, 1, 1) =="&") then 
        actual_value = get_direct(value)
    elseif (value == "a") then
        actual_value = reg_a
    elseif (value == "b") then
        actual_value = reg_b
    else 
        actual_value = tonum(value)
    end

    if (target == "a") then
        reg_a = actual_value
    elseif (target == "b") then
        reg_b = actual_value
    elseif (sub(target, 1, 1) == "&") then 
        set_direct(target, actual_value)
    end
end

function increment(target)
    if (target == "a") then
        reg_a += 1
    elseif (target == "b") then
        reg_b += 1
    elseif (sub(target, 1, 1) == "&") then 
        set_direct(target, get_direct(target)+1)
    end
end

function jump(target)
    if (target == ".output") then
        print_buffer = get_direct(print_buffer_mem)
    elseif (sub(target, 1, 1) == "&") then 
        pc = sub(target,2)
    end
end

function compare(value, target)
    if (value == target) then
        cmp_flag = true
    elseif (tonum(value) == tonum(target)) then
        cmp_flag = true
    else
        cmp_flag = false
    end
end
function jump_compare(target)
    if (cmp_flag == true) then
        jump(target)
    end
end

function _update()
    parse_next()
end

function _draw()
    if (print_buffer ~= "") then
        if (print_buffer == nil) then
            print_buffer = "[nil]"
        end
        print(print_buffer)
        print(" a:"..reg_a.." b:"..reg_b.." pc:"..pc)


        print_buffer = ""
    end
end




__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
