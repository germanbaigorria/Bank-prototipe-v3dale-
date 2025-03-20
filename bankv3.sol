//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract mybankV1

string public MyName;
uint public balanceTokenA;
uint public balanceTokenB;
uint internal priceAB = 10;// a price is 10 Bs == 10 B/A == you need 1 A to buy 10B
address public userAccount;
bool public isDepositedTokenA;
bool public isDepositedTokenB;
//bool public isRegistered;

uint public myFriendBalanceA;

function setName (string memory _name) public {
    myName = _name;
}

function setUserAccount (address _account) public { 
    userAccount = _account;
} 

function depositTokenA() public {
    require(isDepositedTokenA == false, "Ya has depositado A!");
    balanceTokenA = 1000;
    isDepositedTokenA = true;
}

function depositTokenB() public {
    if(isDepositedTokenB == false){
        balanceTokenB = 10000;
        isDepositedTokenB = true;
    } //else { //nothing }
}

function swapFromAToB( uint amountToSwap ) public {
    require(balanceTokenA >= amountToSwap);
    require(amountToSwap >= 10); // nos falto poner este controlador
    balanceTokenA = balanceTokenA - amountToSwap; // Si se modifica balanceA 
    // Si se intenta cambiar menos de 10As, (1 /10 = 0 en Solidity)
    uint amountBToReceive = amountToSwap / priceAB;
    balanceTokenB = balanceTokenB + amountBToReceive; // Se le suma 0 a balanceB
}

function swapFromBToA ( uint amountBToSwap) public {
    require(balanceB >= amountToSwap);
    require (amountToSwap >= 1);
    balanceTokenB = balanceTokenB - amountToSwap;
    uint amountAToReceiv = amountToSwap * pricAB;
    balanceTokenA = balanceTokenA + amountAToReceive;
}

      function transferTokenAToMyFriend(uint amount) public {
    requier(amount <= balanceTokenA);
    balanceTokenA = myFriendBalanceA - amount;
    myFriendBalanceA = myFriendBalanceA + amount;
     }

contract mybankV3 {
    //Estado del contrato addrss public owner;
    
    // Rgistro d usuarios y saldos para cada token
    mapping(address => bool) public isRegistered;
    mapping(address => uint256) public balanceTokenA;
    mapping(address => uint256) public balanceTokenB;

    //Paramtros para simulacion de interes
    mapping(address => uint256) public lastIntrestUpdate;
    uint256 public interestRate = 5; //5% e interes por periodo
    uint256 public interestPeriod = 30 days;

    //Eventos para seguimiento de operaciones
    event Registered(address indexed user);
    event withdrawal(address indexed user, string token, uint256 amount);
    event Transfer(address indexed from, address indexed to, string token, uint256 amount);
    event InterestAccrued(adress inxed user, uint256 interestAmount);
  
    //Modificadores de sguridad
    modifier OnlyOwneer() {
        require(msg.sender ==owner,"solo el owner pude ejcutar esta funcion");
    }    
    modifier onlyRegistered() {
        require(isRegistered)[msg.sender], "Usuario no registrado";
    }
    //Constructor: Establece el owner del contrato
    Constructor(){
        owner = mgs.sender;
    }

    //Registro de usuario
    function rgister() external {
        require(!isRegistered[msg.sender], "Usuario ya registrado");
        isRegistered[msg.sender] = true;
        lastInterestUptdate[msg.sender] = block.timestamp; // Inicializa el calculo de intereses
        emit Registered(mgs.sender);
    }

    //Funciones de retiro para cada token
    function withdrawTokenA(uint256 amount) external onlyRegistered {
        require(balanceTokenA[msg.sender] >= amount, "saldo insuficiente en Token A");
        balanceTokenA[msg.sender] -= amount;
        emit withdrawal(msg.sender, "Token A", amount);
    }
    function withDrawTokenB(uint256 amount) external onlyRegistered {
        require(balanceTokenB[msg.sender] >= amount, "saldo insuficiente en Token B");
        balanceTokenB[msg.sender] -= amount;
        emit withdrawal(msg.sender, "Token B", amount);
    }

    //Funcion para transferir Token A entre usuarios registrados
    function transferTokenAToFriend( address friend, uint256 amount) external onlyRegistered {
        require(isRegistered[friend], "El destinatario no esta registrado");
        require(balanceTokenA[msg.sender] >= amount, "Saldo insuficiente de Token A");

        balanceTokenA[msg.sender] -= amount;
        balanceTokenA[friend] += amount;

        emit Transfer(msg.sender, firend, "Token A", amount);
    }

    // Funcion para actualizar y acumular intereses en el saldo de Token A
    function updateInterest() external onlyRegistered {
        uint256 timeElapse = block.timestamp - lastInterestUpdate[msg.sender];
        require(timeElapsed >= interestPeriod, "No ha transcurrido el periodo minimo para intereses");

    // Calcula cuantos periodos completos han pasado
    uint256 periods = timelapsed / interestPeriod;
    uint256 interet = (balanceTokenA[msg.sender] * interestRate * periods) / 100;

    balanceTokenA[msg.sender] += Interest;
    lastInterestUpdate[msg.sender] = block.timestamp;

    emit InterestAccrued(mgs.sender, interest);
    }

    //Funciones administrativas para ajustar parametros (solo owner)
    function setIntrestRate(uint256 newRate) external OnlyOwner {
        interestRate = newRate;
        }
    function setInterestPeriod(uint256 newPeriod) external  OnlyOwner {
        intrestPeriod = newPeriod;
}
