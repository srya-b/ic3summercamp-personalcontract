let abi = [{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"string","name":"reason","type":"string"}],"name":"Blocked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"when","type":"uint256"},{"indexed":true,"internalType":"address","name":"who","type":"address"},{"indexed":false,"internalType":"string","name":"reason","type":"string"}],"name":"Cancelled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"when","type":"uint256"},{"indexed":true,"internalType":"address","name":"who","type":"address"}],"name":"NewEvent","type":"event"},{"inputs":[],"name":"_owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"when","type":"uint256"}],"name":"addEvent","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"allowed","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"a","type":"address"}],"name":"approveAddress","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"who","type":"address"}],"name":"blockAddress","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"eventHash","type":"uint256"}],"name":"destroyPastEvents","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"events","outputs":[{"internalType":"bool","name":"enabled","type":"bool"},{"internalType":"uint256","name":"when","type":"uint256"},{"internalType":"address","name":"who","type":"address"},{"internalType":"bool","name":"open","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"num","type":"uint256"}],"name":"getEvent","outputs":[{"components":[{"internalType":"bool","name":"enabled","type":"bool"},{"internalType":"uint256","name":"when","type":"uint256"},{"internalType":"address","name":"who","type":"address"},{"internalType":"bool","name":"open","type":"bool"}],"internalType":"struct PersonalContractProxy.Event","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"interval","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"numEvents","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner_url","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"hash","type":"bytes32"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"redeemCard","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"num","type":"uint256"}],"name":"scheduleSlot","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"seedSlots","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"whenFromNum","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}];
let byteCode = "";


let user;
let contractAddress;
let contract;

async function signKey(key) {
    const privateKey = document.getElementById("privateKey").value;

    if(privateKey !== undefined) {
        // Pass private key to metamask 
        const account = await web3.eth.accounts.privateKeyToAccount(privateKey);
        console.log(account);

        const publicAddress = account.address; 
        console.log(publicAddress);

        let data = user;

        console.log("user address: %s", user.address);

        // Sign 
        const signedMessageResponse = await web3.eth.accounts.sign(data, privateKey);
        //const signedMessageResponse = await web3.eth.sign(data, user);
        console.log(signedMessageResponse);

        if(signedMessageResponse !== undefined){

            //Get info from signed message 
            const messageHash = signedMessageResponse.messageHash; 
            const r = signedMessageResponse.r; 
            const s = signedMessageResponse.s; 
            const v = signedMessageResponse.v; 

            // Call contract function 

            const sentValue = await contract.methods.redeemCard(messageHash,v,r,s).send()
              .on('error', function(error) {
                console.log("error encoutnered = " + error);
              }).on('transactionHash', function (txHash) {
                //alert('TX success ' + txHash);
                console.log('tx success');
              }).on('receipt', function(receipt) {
                console.log('Receipt status: %s', receipt.status);
              }).on('confirmation', function(confirmationNumber, receipt) {
                console.log('Confirmation: %s', confirmationNumber);
                console.log('Receipt: %s', receipt);
              });

            console.log(sentValue);
        }

    }
}


async function claimEvent(t) {
  console.log("claimEvent worked: %s", t);
  let scheduletx = await contract.methods.scheduleSlot(parseInt(t)).send()
    .on('error', function(error) {
      alert('Error happened, time not schedule');
    }).on('receipt', function(receipt) {
      alert("successful transcation");
    });
}

async function updateEvents() {
  var num_events = await (contract.methods.numEvents()).call();
  var open = [];

  var eventlist = document.getElementById('eventslist');
  console.log('num_events=%s', num_events);
  let newlist = [];
  for (var i = 1; i <= num_events; i++) {
    var ev = await (contract.methods.getEvent(i)).call();
    
    if (ev.enabled && ev.open) {
      let start = new Date(ev.when * 1000);
      let end = new Date((parseInt(ev.when) + 60*60)*1000);

      let text = "Date: " + start.getDate() + "/" + start.getMonth() + "/" + start.getFullYear() 
               + " " + start.getHours() + ":" + start.getMinutes() + 
               " to " + 
               end.getDate() + "/" + end.getMonth() + "/" + end.getFullYear() 
               + " " + end.getHours() + ":" + end.getMinutes();

      var ul = document.createElement("li");
      var link = document.createElement("a");
      link.href = "javascript:" + "claimEvent(" + ev.when.toString() + ");";
      link.appendChild(document.createTextNode(text));
      ul.appendChild(link);

      newlist.push(ul);      
    } else if (ev.enabled) {
      let start = new Date(ev.when * 1000);
      let end = new Date((parseInt(ev.when) + 60*60)*1000);

      let text = "Date: " + start.getDate() + "/" + start.getMonth() + "/" + start.getFullYear() 
               + " " + start.getHours() + ":" + start.getMinutes() + 
               " to " + 
               end.getDate() + "/" + end.getMonth() + "/" + end.getFullYear() 
               + " " + end.getHours() + ":" + end.getMinutes();
      var ul = document.createElement("li");
      ul.appendChild(document.createTextNode(text));
      ul.style.color = "red";
    }

    while (eventlist.firstChild) {
      eventlist.removeChild(eventlist.firstChild);
    }

    for (var i = 0; i < newlist.length; i++) {
      eventlist.appendChild(newlist[i]);
    }
    await sleep(25);

  }
  document.getElementById('events').style.display = "";
}

async function getContract() {
    console.log('Getting contract')
    contractAddress = document.getElementById("caddress").value;
    contract = new web3.eth.Contract(abi, contractAddress, {
        from: user
    });
   
    console.log('starting loop');
    while (true) {
      await updateEvents();
      await sleep(1000);
    }
  
}

async function init() {
    window.web3 = new Web3(ethereum);

    const accounts = await ethereum.request({ method: 'eth_requestAccounts'});
    user = accounts[0];
    console.log('user %s', user);
    console.log(user);
}


function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
}

window.onload = () => {
    init();

    document.getElementById("redeemButton").addEventListener("click", signKey);
    document.getElementById("contractButton").addEventListener("click", getContract);
}
