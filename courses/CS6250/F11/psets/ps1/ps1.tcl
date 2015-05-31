source tb_compat.tcl
set ns [new Simulator]

set maxnodes 3

set router1 [$ns node]
set router2 [$ns node]



for {set i 1} {$i <= $maxnodes*2} {incr i} {
set node($i) [$ns node]

}


for {set i 1} {$i <= $maxnodes} {incr i} {
set link($i)  [$ns duplex-link $node($i) $router1 100Mb 10ms DropTail]

}



for {set i $i} {$i <= $maxnodes*2} {incr i} {
set link($i)  [$ns duplex-link $node($i) $router2 100Mb 10ms DropTail]

}


set link($i) [$ns duplex-link $router1 $router2 1Mb 10ms DropTail]

$ns rproto Static
$ns run