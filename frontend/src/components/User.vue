<template>
    <div class="card user-card">
        <div class="card-header">
            <slot name="header">Edit Profil</slot>
        </div>
        <div class="card-body">
            <div class="form-group">
                <label class='Front-User' for="username">Username:</label>
                <input id="username" type="text" class="form-control" v-model="formData.user.username" />
            </div>
            <div class="form-group">
                <label class='Front-User' for="email">E-mail:</label>
                <input id="email" type="email" class="form-control" v-model="formData.user.email" />
            </div>
            <div class="button-container">
                <button @click="updateUser" class="btn btn-update">Update</button>
                <button @click="deleteUser" class="btn btn-delete">Delete</button>
            </div>
            <div class="form-group" v-if="passwordVisible">
                <label class='Front-User' for="password">Password:</label>
                <input id="password" type="password" class="form-control" v-model="formData.user.password" />
                <div v-if="passwordError" class="text-danger">Password is required</div>
            </div>
            <button @click="togglePasswordVisibility" class="btn btn-password" >{{ passwordVisible ? 'Hidden Password' : 'Change Password' }}</button>
            <div class="button-container">
                <button @click="updatePassword" class="btn btn-info" v-if="passwordVisible">Update Password</button>
            </div>
        </div>
    </div>
</template>

<script>
import { GET, PUT, DELETE, POST } from '../api/axios';
import { ENDPOINTS } from '../api/endpoints';
import { createToast } from 'mosha-vue-toastify';

export default {
    name: 'User',
    data() {
        return {
            userID: localStorage.getItem('user'),
            token: localStorage.getItem('token'),
            formData: {
                user: {
                    username: '',
                    email: '',
                    password: ''
                }
            },
            passwordError: false,
            passwordVisible: false
        }
    },
    methods: {
        updateUser() {
            PUT(ENDPOINTS.MODIFY_USER + this.userID, this.formData, this.token)
                .then((response) => {
                    createToast({ title: 'Update Success', description: 'You are successfully updated' }, { type: 'success', position: 'bottom-right' });
                    this.getUser()
                })
                .catch((error) => {
                    createToast({ title: 'Update Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
        },
        updatePassword() {
            if (!this.formData.user.password) {
                this.passwordError = true;
                return;
            }
            
            PUT(ENDPOINTS.MODIFY_USER + this.userID, this.formData, this.token)
            .then((response) => {
                createToast({ title: 'Update Password Success', description: 'You are successfully updated Password' }, { type: 'success', position: 'bottom-right' });
                this.getUserPass()
            })
            .catch((error) => {
                createToast({ title: 'Update Password Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
                console.dir(error)
            })
        },
        getUser() {
            GET(ENDPOINTS.GET_USER_BY_ID + this.userID, this.token)
                .then((response) => {
                    this.formData.user.username = response.data.data.username
                    this.formData.user.email = response.data.data.email
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
        getUserPass() {
            GET(ENDPOINTS.GET_USER_BY_ID + this.userID, this.token)
                .then((response) => {
                    this.formData.user.username = response.data.data.username
                    this.formData.user.email = response.data.data.email
                    this.formData.user.password = response.data.data.password
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
        deleteUser() {
            DELETE(ENDPOINTS.DELETE_USER + this.userID, this.token)
                .then(() => {
                    createToast({ title: 'Delete Success', description: 'You are successfully deleted' }, { type: 'success', position: 'bottom-right' });
                    this.$emit("authentication", false)
                })
                .catch((error) => {
                    createToast({ title: 'Delete Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
        },
        togglePasswordVisibility() {
            this.passwordVisible = !this.passwordVisible;
        }
    },
    created() {
        this.getUser()
    }
}
</script>

<style scoped>
.user-card {
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    padding: 20px;
}

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
    padding: 10px 20px;
    font-size: 18px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-password {
    background-color: #3a669f;
    border: 1px solid #3a669f;
    color: white;
}

.btn-update {
    background-color: white;
    border: 1px solid #3a669f;
    color: #3a669f;
    margin-right: 10px; /* Espace entre les boutons */
}

.btn-info{
    background-color: white;
    border: 1px solid #32b966;
    color: #32b966;
    margin-right: 10px; /* Espace entre les boutons */
}

.btn-info:hover {
    background-color: #32b966;
    color: white;
}

.btn-password:hover {
    background-color: white;
    color: #3a669f;
}

.btn-update:hover {
    background-color: #3a669f;
    color: white;
}

.btn-delete {
    background-color: white;
    border: 1px solid #DD3224;
    color: #DD3224;
}

.btn-delete:hover {
    background-color: #DD3224;
    color: white;
}

.Front-User {
    font-weight: bold;
}
</style>
