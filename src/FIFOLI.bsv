/*
FIFO created with a chain of FIFOs, in order to get high latency but max throughput.
May be used to make routing easier over latency-insensitive queues
*/


package FIFOLI;

import FIFO::*;
import Vector::*;

interface FIFOLI#(type t, numeric type steps);
	method Action enq(t d);
	method t first;
	method Action deq;
endinterface

module mkFIFOLI(FIFOLI#(t, steps))
	provisos(Bits#(t, tSz));

	Vector#(steps,FIFO#(t)) fifos <- replicateM(mkFIFO);

	for ( Integer i = 0; i < valueOf(steps)-1; i=i+1 ) begin
		rule relay;
			fifos[i].deq;
			fifos[i+1].enq(fifos[i].first);
		endrule
	end


	method Action enq(t d);
		fifos[0].enq(d);
	endmethod
	method t first;
		return fifos[valueOf(steps)-1].first;
	endmethod
	method Action deq;
		fifos[valueOf(steps)-1].deq;
	endmethod
endmodule

endpackage: FIFOLI

