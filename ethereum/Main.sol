// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProviderContract {
    address public providerAddress;
    string public providerName;
    Seed[] public seeds;
    int256 public totalSales;

    struct Seed {
        string seedName;
        int256 seedPrice;
        string seedQuality;
        int256 seedQuantity;
    }

    modifier onlyProvider() {
        require(
            msg.sender == providerAddress,
            "Only provider can access this function"
        );
        _;
    }

    constructor(string memory _providerName) {
        providerAddress = msg.sender;
        providerName = _providerName;
    }

    function addSeed(
        string memory _seedName,
        string memory _seedQuality,
        int256 _seedPrice,
        int256 _seedQuantity
    ) public onlyProvider {
        seeds.push(Seed(_seedName, _seedPrice, _seedQuality, _seedQuantity));
    }

    function getSeed(
        uint256 _index
    ) public view returns (string memory, int256, string memory, int256) {
        require(_index < seeds.length, "Index out of bounds");
        Seed memory seed = seeds[_index];
        return (
            seed.seedName,
            seed.seedPrice,
            seed.seedQuality,
            seed.seedQuantity
        );
    }

    function sellSeed(uint256 _index, int256 _quantity) public {
        require(_index < seeds.length, "Index out of bounds");
        require(
            _quantity <= seeds[_index].seedQuantity,
            "Insufficient quantity"
        );

        int256 totalPrice = seeds[_index].seedPrice * _quantity;
        seeds[_index].seedQuantity -= _quantity;
        totalSales += totalPrice;
    }
    function getAllSeeds() public view returns (Seed[] memory) {
        return seeds;
    }

    function adjustSeedQuantity(
        uint256 _index,
        int256 _additionalQuantity
    ) public onlyProvider {
        require(_index < seeds.length, "Index out of bounds");
        seeds[_index].seedQuantity += _additionalQuantity;
    }
}

contract ProducerContract {
    address public prroducerAddress;
    string public producerName;
    Crop[] public crops;
    int256 public totalSales;

    struct Crop {
        string cropName;
        string cropQuality;
        int256 cropPrice;
        int256 cropQuantity;
    }

    modifier onlyProducer() {
        require(
            msg.sender == prroducerAddress,
            "Only producer can access this function"
        );
        _;
    }

    constructor(string memory _producerName) {
        prroducerAddress = msg.sender;
        producerName = _producerName;
    }

    function addCrop(
        string memory _cropName,
        string memory _cropQuality,
        int256 _cropPrice,
        int256 _cropQuantity
    ) public onlyProducer {
        crops.push(Crop(_cropName, _cropQuality, _cropPrice, _cropQuantity));
    }

    function getCrop(
        uint256 _index
    ) public view returns (string memory, int256, string memory, int256) {
        require(_index < crops.length, "Index out of bounds");
        Crop memory crop = crops[_index];
        return (
            crop.cropName,
            crop.cropPrice,
            crop.cropQuality,
            crop.cropQuantity
        );
    }

    function sellCrop(uint256 _index, int256 _quantity) public {
        require(_index < crops.length, "Index out of bounds");
        require(
            _quantity <= crops[_index].cropQuantity,
            "Insufficient quantity"
        );

        int256 totalPrice = crops[_index].cropPrice * _quantity;
        crops[_index].cropQuantity -= _quantity;
        totalSales += totalPrice;
    }
    function getAllCrops() public view returns (Crop[] memory) {
        return crops;
    }

    function adjustCropQuantity(
        uint256 _index,
        int256 _additionalQuantity
    ) public onlyProducer {
        require(_index < crops.length, "Index out of bounds");
        crops[_index].cropQuantity += _additionalQuantity;
    }
}

contract ProcessorContract {
    address public processorAddress;
    string public processorName;
    Product[] public products;
    int256 public totalSales;

    struct Product {
        string productName;
        string productQuality;
        int256 productPrice;
        int256 productQuantity;
    }

    modifier onlyProcessor() {
        require(
            msg.sender == processorAddress,
            "Only processor can access this function"
        );
        _;
    }

    constructor(string memory _processorName) {
        processorAddress = msg.sender;
        processorName = _processorName;
    }

    function addProduct(
        string memory _productName,
        string memory _productQuality,
        int256 _productPrice,
        int256 _productQuantity
    ) public onlyProcessor {
        products.push(
            Product(
                _productName,
                _productQuality,
                _productPrice,
                _productQuantity
            )
        );
    }

    function getProduct(
        uint256 _index
    ) public view returns (string memory, int256, string memory, int256) {
        require(_index < products.length, "Index out of bounds");
        Product memory product = products[_index];
        return (
            product.productName,
            product.productPrice,
            product.productQuality,
            product.productQuantity
        );
    }

    function sellProduct(uint256 _index, int256 _quantity) public {
        require(_index < products.length, "Index out of bounds");
        require(
            _quantity <= products[_index].productQuantity,
            "Insufficient quantity"
        );

        int256 totalPrice = products[_index].productPrice * _quantity;
        products[_index].productQuantity -= _quantity;
        totalSales += totalPrice;
    }
    function getAllProducts() public view returns (Product[] memory) {
        return products;
    }

    function adjustProductQuantity(
        uint256 _index,
        int256 _additionalQuantity
    ) public onlyProcessor {
        require(_index < products.length, "Index out of bounds");
        products[_index].productQuantity += _additionalQuantity;
    }
}

contract DistributorContract {
    address public distributor;
    string public distributorName;
    int256 public ratePerKilometer;

    struct Shipment {
        address processor;
        address retailer;
        int256 distanceInKm;
        int256 totalPrice;
        bool delivered;
    }

    mapping(bytes32 => Shipment) public shipments;

    constructor(string memory _distributorName, int256 _ratePerKilometer) {
        distributor = msg.sender;
        distributorName = _distributorName;
        ratePerKilometer = _ratePerKilometer;
    }

    modifier onlyOwner() {
        require(
            msg.sender == distributor,
            "Only distributor can call this function"
        );
        _;
    }

    function createShipment(
        address _processor,
        int256 _distanceInKm
    ) public onlyOwner returns (bytes32) {
        int256 totalPrice = _distanceInKm * ratePerKilometer;

        bytes32 shipmentId = sha256(
            abi.encodePacked(msg.sender, _processor, block.timestamp)
        );
        shipments[shipmentId] = Shipment(
            _processor,
            msg.sender,
            _distanceInKm,
            totalPrice,
            false
        );

        return shipmentId;
    }

    function deliverShipment(bytes32 _shipmentId) public {
        require(
            shipments[_shipmentId].processor == msg.sender,
            "Only processor can mark shipment as delivered"
        );
        shipments[_shipmentId].delivered = true;
    }
}

contract RetailerContract {
    address public retailerAddress;
    string public retailerName;
    Item[] public items;
    int256 public totalSales;

    struct Item {
        string itemName;
        int256 itemPrice;
        string itemQuality;
        int256 itemQuantity;
    }

    modifier onlyRetailer() {
        require(
            msg.sender == retailerAddress,
            "Only retailer can access this function"
        );
        _;
    }

    constructor(string memory _retailerName) {
        retailerAddress = msg.sender;
        retailerName = _retailerName;
    }

    function addItem(
        string memory _itemName,
        string memory _itemQuality,
        int256 _itemPrice,
        int256 _itemQuantity
    ) public onlyRetailer {
        items.push(Item(_itemName, _itemPrice, _itemQuality, _itemQuantity));
    }

    function getItem(
        uint256 _index
    ) public view returns (string memory, int256, string memory, int256) {
        require(_index < items.length, "Index out of bounds");
        Item memory item = items[_index];
        return (
            item.itemName,
            item.itemPrice,
            item.itemQuality,
            item.itemQuantity
        );
    }

    function sellItem(uint256 _index, int256 _quantity) public {
        require(_index < items.length, "Index out of bounds");
        require(
            _quantity <= items[_index].itemQuantity,
            "Insufficient quantity"
        );

        int256 totalPrice = items[_index].itemPrice * _quantity;
        items[_index].itemQuantity -= _quantity;
        totalSales += totalPrice;
    }
    function getAllItems() public view returns (Item[] memory) {
        return items;
    }

    function adjustItemQuantity(
        uint256 _index,
        int256 _additionalQuantity
    ) public onlyRetailer {
        require(_index < items.length, "Index out of bounds");
        items[_index].itemQuantity += _additionalQuantity;
    }
}
