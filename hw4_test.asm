############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
############################ Add more names if needed ####################################

.data

Name1: .asciiz "Alm"
Name2: .asciiz "Marth"
Name3: .asciiz "Katarina"
Name4: .asciiz "Fir"
Name5: .asciiz "Reinhardt"
Name6: .asciiz "Lynndis"
Name7: .asciiz "Hector"
Name8: .asciiz "Io"
I: .word 8
J: .word 12

.text
.macro addPerson(%label)
    add $a0, $0, $s0        # pass network address to add_person
    la $a1, %label
    jal add_person
.end_macro
.macro addRelation(%label1, %label2, %imm)
    add $a0, $0, $s0        # pass network address to add_person
    la $a1, %label1
    la $a2, %label2
    li $a3, %imm
    jal add_relation
.end_macro
main:
    lw $a0, I
    lw $a1, J
    jal create_network
    add $s0, $v0, $0        # network address in heap

    add $a0, $0, $s0        # pass network address to add_person
    addPerson(Name1)
    addRelation(Name1, Name2, 1)
    addRelation(Name2, Name2, 1)
    addRelation(Name1, Name1, 1)
    addPerson(Name1)
    addPerson(Name2)
    
    add $a0, $0, $s0        # pass network address to add_person
    la $a1, Name1
    la $a2, Name2
    li $a3, -1
    jal add_relation
    
    addRelation(Name1, Name2, 4)
    addRelation(Name1, Name2, 1)
    addRelation(Name1, Name2, 1)
    addPerson(Name3)
    addPerson(Name4)
    addPerson(Name5)
    addPerson(Name6)
    addPerson(Name7)
    addPerson(Name8)
    addRelation(Name1, Name2, 1)
    addRelation(Name1, Name5, 1)
    addRelation(Name1, Name4, 0)
    addRelation(Name2, Name8, 3)
    addRelation(Name2, Name6, 1)
    addRelation(Name2, Name5, 1)
    addRelation(Name2, Name4, 1)
    addRelation(Name5, Name8, 2)
    addRelation(Name5, Name6, 1)
    addRelation(Name5, Name7, 1)
    addRelation(Name6, Name7, 3)
    addRelation(Name7, Name8, 0)
    
    add $a0, $0, $s0        # pass network address to add_person
    la $a1, Name1
    jal get_distant_friends

exit:
    li $v0, 10
    syscall
.include "hw4.asm"
