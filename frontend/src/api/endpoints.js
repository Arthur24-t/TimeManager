export const ENDPOINTS = {
    //USER
    GET_USER_BY_EMAIL_USERNAME: '/api/users',
    GET_USER_BY_ID: '/api/users/', // + add userID
    CREATE_USER: '/api/users',
    MODIFY_USER: '/api/users/', // + add userID
    DELETE_USER: '/api/users/', // + add userID
    //WORKING TIME
    GET_ALL_TIME: '/api/workingtimes/',
    GET_ONE_TIME: '/api/workingtimes/',
    CREATE_TIME: '/api/workingtimes/', // + add userID
    MODIFY_TIME: '/api/workingtimes/', // + add workingtime id
    DELETE_TIME: '/api/workingtimes/', // + add workingtime id
    //CLOCKING
    GET_CLOCK: '/api/clocks/', // + add userID
    CREATE_CLOCK: '/api/clocks/', // + add userID
}