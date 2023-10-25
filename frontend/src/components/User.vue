<template>
    <div class="card">
        <div class="card-header">
            <slot name="header">User Info</slot>
        </div>
        <div class="card-body">
            <div class="form-group">
                <label for="username">Username :</label>
                <input id="username" type="text" class="form-control" v-model="formData.user.username" />
            </div>
            <div class="form-group">
                <label for="email">E-mail :</label>
                <input id="email" type="email" class="form-control" v-model="formData.user.email" />
            </div>
            <div class="button-container">
                <button @click="updateUser" class="btn btn-primary">Update</button>
            </div>
            <div class="button-container">
                <button @click="updateShowCreateUser" class="btn btn-primary">Add a User</button>
            </div>
            <div v-if="showCreateUser">
                <div class="form-group">
                    <label for="username">Username :</label>
                    <input id="username" type="text" class="form-control" v-model="createUserForm.user.username" />
                </div>
                <div class="form-group">
                    <label for="email">E-mail :</label>
                    <input id="email" type="email" class="form-control" v-model="createUserForm.user.email" />
                </div>
                <div class="button-container">
                <button @click="createUser" class="btn btn-primary">Create User</button>
            </div>
            </div>
        </div>
        <div class="card-footer">
            <button @click="deleteUser" class="btn btn-secondary">Delete</button>
        </div>
    </div>
</template>
  
<script>
import { GET, PUT, DELETE, POST } from '../api/axios';
import { ENDPOINTS } from '../api/endpoints';

export default {
    name: 'User',
    props: {
        userID: {
            type: Number,
            required: true,
        },
    },
    data() {
        return {
            formData: {
                user: {
                    username: '',
                    email: ''
                }
            },
            createUserForm: {
                user: {
                    username: '',
                    email: ''
                }
            },
            showCreateUser: false
        }
    },
    methods: {
        updateUser() {
            PUT(ENDPOINTS.MODIFY_USER + this.userID, this.formData)
                .then((response) => {
                    this.getUser()
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
        updateShowCreateUser() {
            this.showCreateUser = !this.showCreateUser
        },
        getUser() {
            GET(ENDPOINTS.GET_USER_BY_ID + this.userID)
                .then((response) => {
                    this.formData.user.username = response.data.data.username
                    this.formData.user.email = response.data.data.email
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
        createUser() {
            POST(ENDPOINTS.CREATE_USER, this.createUserForm)
            .then((response) => {console.dir("created")})
            .catch((error) => {console.dir(error)})
        },
        deleteUser() {
            DELETE(ENDPOINTS.DELETE_USER + this.userID)
                .then(() => {
                    this.$emit("authentication", false)
                })
                .catch((error) => {
                    console.dir(error)
                })
        }
    },
    created() {
        this.getUser();
    },
}
</script>
  
<style scoped>
.form-group {
    margin: 10px 0;
}

.form-control {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.button-container {
    text-align: right;
    margin-top: 20px;
}

.btn {
    color: #fff;
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.btn-primary {
    background-color: #007BFF;
}

.btn-secondary {
    background-color: red;
}
</style>
  