pragma solidity 0.8.0;


contract Car {
    address private factory;
    address public owner;
    // ... other car details

    constructor(address _factory){
        factory = _factory;
    }

    function setOwner(address _owner) external {
        require(msg.sender == factory, "INVALID_CALLER: caller is not the factory");
        require(owner == address(0), "ALREADY_OWNED: Car has already been sold");
        owner = _owner;
    }
}


contract CarStore {
    mapping(address => bool) admins;
    mapping(address => uint256) carsPrices;
    address[] private cars;

    event NewCar(address indexed _car, uint256 _price, uint256 _carNumber);
    event SellCar(address indexed _car, address indexed buyer);

    constructor(){
        admins[msg.sender] = true;
    }

    modifier onlyAdmin () {
    require(admins[msg.sender], "INVALID_CALLER: caller is not an admin");
    _;
  }

    function addCar(uint256 _price) external {
        uint256 totalCars = cars.length;
        Car car = new Car{salt:keccak256(abi.encodePacked(totalCars))}(address(this));
        address carAddress = address(car);
        cars.push(carAddress);
        carsPrices[carAddress] = _price;
        emit NewCar(carAddress, _price, totalCars+1);
    }

    function buyCar(address _car) external payable {
        require(carsPrices[_car] >= msg.value, "INVALID_PRICE: price is lower than required");
        address buyer = msg.sender;
        Car(_car).setOwner(buyer);
        emit SellCar(_car, buyer);
    }

    function setCarBuyer(address _car, address _carOwner) external onlyAdmin {
        Car(_car).setOwner(_carOwner);
        emit SellCar(_car, _carOwner);
    }

    function withdraw(address payable _to) external onlyAdmin {
        require(_to != address(0), "INVALID_TO: Withdrawal to zero address is not allowed");
        _to.transfer(address(this).balance);
    }
    
}