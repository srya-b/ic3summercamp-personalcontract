//var myContractAddress = '0x2Debf19564C7ca2c23a179A2b43DC9615cE23ff1'
//var myContractAddress = '0xdEE5bCBAa461cF6F432F54389d45BBd79e07160C';
const updateInterval = 1000; // 1 second

// **** Internal functions ****

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
}

// **** Access values on blockchain ****

async function updateEvents() {
	/* TODO: list the events */
  /* console.log('calling numEvents') */;
  var num_events = await (proxyContract.methods.numEvents().call());
  var unclaimed = [];
  var claimed = [];
  var oneHour = 60 * 60;
  //console.log('numevents = %s', num_events);
  //console.log('numseen = %s', numSeen);
	for (var i = numSeen+1; i <= num_events; i++) {
  	var event = await (proxyContract.methods.events(i).call());
    console.log('event = %s', event);
    if (event.enabled) {
      console.log('enabled');
      var newEvent = new Object();
      let w = parseInt(event.when) * 1000;
      newEvent.title = 'Office hours';
      newEvent.start = moment(w).format();
      console.log(w);
      console.log('newEvent: ' + moment(w).format());
      newEvent.end = moment(w + oneHour * 1000).format();
      console.log('newEvent: ' + moment(w + oneHour).format());
      newEvent.allday = false;
      if (!event.open) {
      	newEvent.backgroundColor = '#E33C18';
      }

      $("#calendar").fullCalendar('renderEvent', newEvent, true);
    }
    numSeen = num_events;
/* 		if (event.enabled && event.open) 
		      claimed.push(i);
		    else
		      unclaimed.push(i);*/
  }
  $("#unclaimedEvents").text(unclaimed);
  $("#claimedEvents").text(claimed);
}


// **** Global functions ****

async function addEvent2(startTime, endTime) {
    // Wait for 
    var prev_num_events = await (proxyContract.methods.numEvents().call());
    
    confirm("this is the timestamp being given: " + startTime.unix());
    proxyContract.methods.addEvent( startTime.unix() ).send({from: user});  
    //console.log("Transaction sent");
		while (true) {
        var num_events = await (proxyContract.methods.numEvents().call());
        if (prev_num_events != num_events) {
            break
        }
        await sleep(1000);
    }
    
    numSeen += 1;
    
    //console.log("Transaction completed!");
}


async function initCalender() {
	 $('#calendar').fullCalendar({
   				selectable: true,
	        header: {
	          left: 'prev,next today',
	          center: 'title',
	          right: 'month,agendaWeek,agendaDay'
	        },
/*           dayClick: function(date) {
            alert('clicked ' + date.format());
          }, */
          select: async function(startDate, endDate) {
          	//alert('selected ' + startDate.format() + ' to ' + endDate.format());
						var ok = confirm("Confirm new event from " + startDate.format("dddd, MMMM Do YYYY, h:mm:ss a") + ' to ' + endDate.format("dddd, MMMM Do YYYY, h:mm:ss a"));
            var newEvent = new Object();
            newEvent.title = 'Office hours';
            newEvent.start = moment(startDate).format();
            newEvent.end = moment(endDate).format();
            newEvent.allday = false;
            
            await addEvent2(startDate, endDate);
            
            $("#calendar").fullCalendar('renderEvent', newEvent);
          },
	        defaultView: 'month',
	        editable: true,
	});

}


// **** Initialization ****

async function init() {
    const myContractAddress = prompt("Contract adress");
    window.web3 = new Web3(ethereum)

    window.user = (await ethereum.request({ method: 'eth_requestAccounts'}))[0]
    $('#user').text(user)

		await initCalender();

	  const proxyABI = JSON.parse($('#proxyABI').text());
    const mainABI = JSON.parse($('#mainABI').text());
    window.proxyContract = new web3.eth.Contract(proxyABI, myContractAddress);
    window.mainContract = new web3.eth.Contract(mainABI, myContractAddress);
    window.numSeen = 0;
        
    //console.log('Starting update Events');

    await updateEvents();

    while (true) {
        await updateEvents();
        await sleep(updateInterval);
    }
}

init()
