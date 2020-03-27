pragma solidity ^0.6.0;

import "../GelatoCoreEnums.sol";
import "./IGelatoUserProxy.sol";
import "../../conditions/IGelatoCondition.sol";
import "../../actions/IGelatoAction.sol";

/// @title IGelatoCore - solidity interface of GelatoCore
/// @notice canExecute API and minting, execution, cancellation of ExecutionClaims
/// @dev all the APIs and events are implemented inside GelatoCore
interface IGelatoCore {

    /**
     * @dev API for minting execution claims on gelatoCore
     * @notice re-entrancy guard because accounting ops are present inside fn
     * @notice msg.value is a refundable deposit - only a fee if executed
     * @notice minting event split into two, due to stack too deep issue
     */
    function mintExecutionClaim(
        address _selectedExecutor,
        IGelatoCondition _condition,
        bytes calldata _conditionPayloadWithSelector,
        IGelatoAction _action,
        bytes calldata _actionPayloadWithSelector
    )
        external
        payable;

    /**
     * @notice If return value == 6, the claim is executable
     * @dev The API for executors to check whether a claim is executable.
     *       Caution: there are no guarantees that CanExecuteResult and/or reason
     *       are implemented in a logical fashion by condition/action developers.
     * @return GelatoCoreEnums.CanExecuteResults The outcome of the canExecuteCheck
     * @return reason The reason for the outcome of the canExecute Check
     */
    function canExecute(
        uint256 _executionClaimId,
        address _user,
        IGelatoUserProxy _userProxy,
        IGelatoCondition _condition,
        bytes calldata _conditionPayloadWithSelector,
        IGelatoAction _action,
        bytes calldata _actionPayloadWithSelector,
        uint256[3] calldata _conditionGasActionTotalGasMinExecutionGas,
        uint256 _executionClaimExpiryDate,
        uint256 _mintingDeposit
    )
        external
        view
        returns (GelatoCoreEnums.CanExecuteResults, uint8 reason);


    /**
     * @notice the API executors call when they execute an executionClaim
     * @dev if return value == 0 the claim got executed
     */
    function execute(
        uint256 _executionClaimId,
        address _user,
        IGelatoUserProxy _userProxy,
        IGelatoCondition _condition,
        bytes calldata _conditionPayloadWithSelector,
        IGelatoAction _action,
        bytes calldata _actionPayloadWithSelector,
        uint256[3] calldata _conditionGasActionTotalGasMinExecutionGas,
        uint256 _executionClaimExpiryDate,
        uint256 _mintingDeposit
    )
        external;


}