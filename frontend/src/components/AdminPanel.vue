<template>
    <div class="card admin-card">
        <div class="card-header">
            <div class="admin">
                <slot name="header">Admin Panel</slot>
                <div class="btn-container">
                    <button class="toggle-btn user-btn" :class="{isSelected : toggleStatus === 'user'}" @click="updateToggleStatus('user')">USERS</button>
                    <button class="toggle-btn team-btn" :class="{isSelected : toggleStatus === 'teams'}" @click="updateToggleStatus('teams')">TEAMS</button>
                </div>
            </div>
        </div>
        <div class="card-body admin-body">
            <all-admin-user v-if="toggleStatus === 'user'"/>
            <all-admin-team v-if="toggleStatus === 'teams'"/>
        </div>
    </div>
</template>

<script>
import AllAdminUser from './AllAdminUser.vue';
import AllAdminTeam from './AllAdminTeam.vue';

    export default {
       name: 'AdminPanel',
       components: {
        AllAdminUser,
        AllAdminTeam
       }, 
       data() {
        return {
            toggleStatus: 'user'
        }
       },
       methods: {
        updateToggleStatus(e) {
           this.toggleStatus = e 
        }
       },
    }
</script>

<style scoped>

.admin-card {
    overflow-y: scroll;
    box-shadow: 0px 8px 13px -3px rgba(0, 0, 0, 0.07);
    border-radius: 4px;
    height: 90vh;
}

.admin-body {
    padding: 3rem;
}

.admin-card::-webkit-scrollbar {
    width: 3px;
}

/* Track */
.admin-card::-webkit-scrollbar-track {
    box-shadow: inset 0 0 5px grey;
    border-radius: 10px;
}

/* Handle */
.admin-card::-webkit-scrollbar-thumb {
    background: grey;
    border-radius: 10px;
}

/* Handle on hover */
.admin-card::-webkit-scrollbar-thumb:hover {
    background: #b30000;
}

.admin {
    display: flex;
    flex-direction: column;
    font-size: 1.2rem;
    font-weight: bold;
    gap: 1.5rem
}

.btn-container {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
}


.toggle-btn {
    padding: 1rem 7rem;
    cursor: pointer;
    border: 1px solid;
    font-size: 18px;
    background-color: #a3665c;
    color: white;
}
.isSelected, .toggle-btn:hover {
    background-color: #5C99A3;
    font-weight: bold;
}

.user-btn {
    border-radius: 1rem 0px 0px 1rem;
}

.team-btn {
    border-radius: 0px 1rem 1rem 0px;
}

@media (max-width: 900px) {
    .user-btn, .team-btn {
    border-radius: 1rem;
    }
}

</style>