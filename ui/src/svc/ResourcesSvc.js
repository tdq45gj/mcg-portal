class ResourcesService {
    constructor(serverClient) {
        this.serverClient = serverClient;
    }

    async getResourcesForUser(userId, enableCache = false) {
        const response = await this.serverClient.fetch(`/api/accounts/${userId}/resources`, {
            enableCache,
        });
        return response.json();
    }

    async deleteResource(userId, resourceId) {
        return this.serverClient.fetch(`/api/accounts/${userId}/resources/${resourceId}`, {
            method: 'DELETE',
        })
    }

    async createResource(userId, resourceName) {
        return this.serverClient.fetch(`/api/accounts/${userId}/resources`, {
            method: 'POST',
            body: JSON.stringify({
                name: resourceName,
            })
        })
    }
}

export default ResourcesService;
