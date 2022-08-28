// SPDX-Lisence-Identifier: GLP-3.0
pragma solidity >=0.6.0;

contract SimpleStorage{
    uint nums;

    function set(uint _nums)public{
        nums=_nums;
    }
    function get()public view returns(uint){
        return nums;
    }
}