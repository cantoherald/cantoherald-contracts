// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';

contract CantoHerald is Initializable {
    // mapping from address to array index of a subscriber
    mapping(address => uint256) public subscribedAt;

    /// @dev we also put the subscribers in an array to be able to pick random ones
    /// @dev sure could be done more gas efficient but should be fine for Canto
    address[] public subscribers;

    event Subscribed(address indexed subscriber);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function subscribe() external {
        require(subscribedAt[msg.sender] == 0, 'Already subscribed');
        subscribedAt[msg.sender] = block.timestamp;
        subscribers.push(msg.sender);
        emit Subscribed(msg.sender);
    }

    function getSubscribersCount() external view returns (uint256) {
        return subscribers.length;
    }

    /// @dev utility function that can return subscribers in chunks of 100s
    /// @dev this is to avoid out of gas errors when calling from the frontend
    function getSubscribers(
        uint256 offset
    ) external view returns (address[] memory, uint256[] memory) {
        require(subscribers.length > 0, 'No subscribers available');
        require(offset < subscribers.length, 'Offset out of bounds');

        address[] memory addresses = new address[](100);
        uint256[] memory timestamps = new uint256[](100);
        uint256 start = subscribers.length < 100 ? 0 : subscribers.length - 100;

        if (offset != 0) {
            start = offset;
        }

        for (uint256 i = 0; i < 100 && start + i < subscribers.length; i++) {
            addresses[i] = subscribers[start + i];
            timestamps[i] = subscribedAt[addresses[i]];
        }

        return (addresses, timestamps);
    }
}
