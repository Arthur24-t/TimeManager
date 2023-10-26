<template>
    <div class="card user-card">
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
        </div>
        <div class="card-footer">
            <button @click="deleteUser" class="btn btn-secondary">Delete</button>
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
            formData: {
                user: {
                    username: '',
                    email: ''
                }
            },
        }
    },
    methods: {
        updateUser() {
            PUT(ENDPOINTS.MODIFY_USER + this.userID, this.formData)
                .then((response) => {
                    createToast({ title: 'Update Success', description: 'You are sucessfully updated' }, { type: 'success', position: 'bottom-right' });
                    this.getUser()
                })
                .catch((error) => {
                    createToast({ title: 'Update Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
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
        deleteUser() {
            DELETE(ENDPOINTS.DELETE_USER + this.userID)
                .then(() => {
                    createToast({ title: 'Delete Success', description: 'You are sucessfully deleted' }, { type: 'success', position: 'bottom-right' });
                    this.$emit("authentication", false)
                })
                .catch((error) => {
                    createToast({ title: 'Delete Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
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
.user-card {
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    border-radius: 4px;
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
    margin-top: 20px;
    padding: 10px 20px;
    font-size: 18px;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-primary {
    background-color: #3a669f;
}

.btn-primary:hover {
    background-color: #504ba9;
}

.btn-secondary {
    background-color: #DD3224;
}

.btn-secondary:hover {
    background-color: #9A2319;
}
</style>
  