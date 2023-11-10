export const ENDPOINTS = {
    //USER
    GET_USER_BY_EMAIL_USERNAME: '/api/users',
    GET_USER_BY_ID: '/api/users/', // + add userID
    CREATE_USER: '/register',
    ADMIN_CREATE_USER: '/api/users',
    LOGIN_USER: '/login',
    MODIFY_USER: '/api/users/', // + add userID
    DELETE_USER: '/api/users/', // + add userID
    ADD_USER_TO_TEAM: '/api/users/', // + add :user_id/teams/:team_id
    DELETE_USER_TO_TEAM: '/api/users/', // + add :user_id/teams/:team_id
    GET_ALL_USER: '/api/users',
    //WORKING TIME
    GET_ALL_TIME: '/api/workingtimes/',
    GET_ONE_TIME: '/api/workingtimes/',
    CREATE_TIME: '/api/workingtimes/', // + add userID
    MODIFY_TIME: '/api/workingtimes/', // + add workingtime id
    DELETE_TIME: '/api/workingtimes/', // + add workingtime id
    //CLOCKING
    GET_CLOCK: '/api/clocks/', // + add userID
    CREATE_CLOCK: '/api/clocks/', // + add userID
    //TEAMS
    GET_ALL_TEAMS: '/api/teams',
    GET_ALL_USER_IN_TEAM: '/api/teams/', // + add teamID
    CREATE_TEAM: '/api/teams',
    MODIFY_TEAM_NAME: '/api/teams/', // + add teamID
    DELETE_TEAM: '/api/teams/', // + add teamID
    //TEAMS
    GET_ALL_TEAM: '/api/teams'
}