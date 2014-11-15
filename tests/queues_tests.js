///////////////////   Tests    /////////////////////////////
pq = require("../js/queues");

var queue = new pq.PriorityQueue();
        
queue.push({p:'two'}, 2);
queue.push({p:'three'}, 3);
queue.push({p:'five'}, 5);
queue.push({p:'1st one'}, 1);
queue.push({p:'zero'}, 0);
queue.push({p:'nine'}, 9);
queue.push({p:'2nd one'}, 1);
        
console.log(queue.heap.toString() === ',0,1,1,3,2,9,5'); // => 0,1,1,3,2,9,5 

console.log(queue.pop().p === 'zero' ); // => {p:'zero'}
console.log(queue.pop().p === '1st one'); // => {p:'1st one'}
console.log(queue.heap.toString() === ',1,2,9,3,5'); // => 1,2,9,3,5

queue.push({p:'one-half'}, 0.5);
console.log(queue.heap.toString() === ',0.5,2,1,3,5,9'); // => 0.5,2,1,3,5,9

// TODO: test negative numbers
