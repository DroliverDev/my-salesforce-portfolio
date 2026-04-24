@RestResource(urlMapping='/portfolio/*')
global class PortfolioRestController {
    @HttpGet
    global static void doGet() {
        handleRequest('GET');
    }

    @HttpPost
    global static void doPost() {
        handleRequest('POST');
    }

    @HttpPut
    global static void doPut() {
        handleRequest('PUT');
    }

    @HttpDelete
    global static void doDelete() {
        handleRequest('DELETE');
    }

    private static void handleRequest(String methodName) {
        try {
            Route route = parseRoute();

            if (String.isBlank(route.resource)) {
                respondError(404, 'Resource not found.');
                return;
            }

            if (methodName == 'GET') {
                handleGet(route);
            } else if (methodName == 'POST') {
                handlePost(route);
            } else if (methodName == 'PUT') {
                handlePut(route);
            } else if (methodName == 'DELETE') {
                handleDelete(route);
            } else {
                respondError(405, 'Method not allowed.');
            }
        } catch (PortfolioService.ValidationException ex) {
            respondError(400, ex.getMessage());
        } catch (PortfolioService.NotFoundException ex) {
            respondError(404, ex.getMessage());
        } catch (DmlException ex) {
            respondError(400, ex.getDmlMessage(0));
        } catch (Exception ex) {
            respondError(500, ex.getMessage());
        }
    }

    private static void handleGet(Route route) {
        if (route.resource == 'skills') {
            if (route.recordId == null) {
                respondSuccess(200, SkillService.getAll());
                return;
            }

            SkillDTO dto = SkillService.getById(route.recordId);
            if (dto == null) {
                throw new PortfolioService.NotFoundException('Skill not found.');
            }
            respondSuccess(200, dto);
            return;
        }

        if (route.resource == 'projects') {
            if (route.recordId == null) {
                respondSuccess(200, ProjectService.getAll());
                return;
            }

            ProjectDTO dto = ProjectService.getById(route.recordId);
            if (dto == null) {
                throw new PortfolioService.NotFoundException('Project not found.');
            }
            respondSuccess(200, dto);
            return;
        }

        if (route.resource == 'profile') {
            ProfileDTO dto = route.recordId == null ? ProfileService.getDefault() : ProfileService.getById(route.recordId);
            if (dto == null) {
                throw new PortfolioService.NotFoundException('Profile not found.');
            }
            respondSuccess(200, dto);
            return;
        }

        respondError(404, 'Resource not found.');
    }

    private static void handlePost(Route route) {
        if (route.resource == 'skills') {
            SkillDTO created = SkillService.create(parseSkillDTO(getRequiredBody()));
            respondSuccess(201, created);
            return;
        }

        if (route.resource == 'projects') {
            ProjectDTO created = ProjectService.create(parseProjectDTO(getRequiredBody()));
            respondSuccess(201, created);
            return;
        }

        if (route.resource == 'profile') {
            ProfileDTO created = ProfileService.create(parseProfileDTO(getRequiredBody()));
            respondSuccess(201, created);
            return;
        }

        respondError(404, 'Resource not found.');
    }

    private static void handlePut(Route route) {
        if (route.resource == 'skills') {
            if (route.recordId == null) {
                throw new PortfolioService.ValidationException('Skill id is required in the URI.');
            }

            SkillDTO updated = SkillService.updateById(route.recordId, parseSkillDTO(getRequiredBody()));
            respondSuccess(200, updated);
            return;
        }

        if (route.resource == 'projects') {
            if (route.recordId == null) {
                throw new PortfolioService.ValidationException('Project id is required in the URI.');
            }

            ProjectDTO updated = ProjectService.updateById(route.recordId, parseProjectDTO(getRequiredBody()));
            respondSuccess(200, updated);
            return;
        }

        if (route.resource == 'profile') {
            String rawBody = getRequiredBody();
            Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(rawBody);
            Id profileId = route.recordId;

            String bodyId = payload == null ? null : (String) payload.get('id');
            if (profileId == null && !String.isBlank(bodyId)) {
                profileId = PortfolioService.parseId(bodyId, 'id');
            }
            if (profileId == null) {
                ProfileDTO defaultProfile = ProfileService.getDefault();
                if (defaultProfile == null || String.isBlank(defaultProfile.id)) {
                    throw new PortfolioService.ValidationException('No default profile found. Provide profile id to update.');
                }
                profileId = PortfolioService.parseId(defaultProfile.id, 'id');
            }

            ProfileDTO updated = ProfileService.updateById(profileId, parseProfileDTO(rawBody));
            respondSuccess(200, updated);
            return;
        }

        respondError(404, 'Resource not found.');
    }

    private static void handleDelete(Route route) {
        if (route.resource == 'skills') {
            if (route.recordId == null) {
                throw new PortfolioService.ValidationException('Skill id is required in the URI.');
            }

            SkillService.deleteById(route.recordId);
            respondSuccess(200, null);
            return;
        }

        if (route.resource == 'projects') {
            if (route.recordId == null) {
                throw new PortfolioService.ValidationException('Project id is required in the URI.');
            }

            ProjectService.deleteById(route.recordId);
            respondSuccess(200, null);
            return;
        }

        if (route.resource == 'profile') {
            Id profileId = route.recordId;
            if (profileId == null) {
                String queryId = RestContext.request.params == null ? null : RestContext.request.params.get('id');
                if (!String.isBlank(queryId)) {
                    profileId = PortfolioService.parseId(queryId, 'id');
                }
            }
            if (profileId == null) {
                throw new PortfolioService.ValidationException('Profile id is required in the URI or query string.');
            }

            ProfileService.deleteById(profileId);
            respondSuccess(200, null);
            return;
        }

        respondError(404, 'Resource not found.');
    }

    private static String getRequiredBody() {
        String body = RestContext.request.requestBody == null ? null : RestContext.request.requestBody.toString();
        if (String.isBlank(body)) {
            throw new PortfolioService.ValidationException('Request body is required.');
        }

        return body;
    }

    private static SkillDTO parseSkillDTO(String rawBody) {
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(rawBody);
        SkillDTO dto = new SkillDTO();
        dto.id = (String) payload.get('id');
        dto.name = (String) payload.get('name');
        dto.nameEn = (String) payload.get('nameEn');
        dto.level = (String) payload.get('level');
        dto.category = (String) payload.get('category');
        dto.profileId = (String) payload.get('profileId');
        dto.displayOrder = toInteger(payload.get('displayOrder'));
        return dto;
    }

    private static ProjectDTO parseProjectDTO(String rawBody) {
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(rawBody);
        ProjectDTO dto = new ProjectDTO();
        dto.id = (String) payload.get('id');
        dto.name = (String) payload.get('name');
        dto.nameEn = (String) payload.get('nameEn');
        dto.description = (String) payload.get('description');
        dto.descriptionEn = (String) payload.get('descriptionEn');
        dto.shortDescription = (String) payload.get('shortDescription');
        dto.shortDescriptionEn = (String) payload.get('shortDescriptionEn');
        dto.slug = (String) payload.get('slug');
        dto.architectureNotes = (String) payload.get('architectureNotes');
        dto.imageUrl = (String) payload.get('imageUrl');
        dto.githubUrl = (String) payload.get('githubUrl');
        dto.projectUrl = (String) payload.get('projectUrl');
        dto.isFeatured = toBoolean(payload.get('isFeatured'));
        dto.profileId = (String) payload.get('profileId');
        dto.techStack = toStringList(payload.get('techStack'));
        return dto;
    }

    private static ProfileDTO parseProfileDTO(String rawBody) {
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(rawBody);
        ProfileDTO dto = new ProfileDTO();
        dto.id = (String) payload.get('id');
        dto.name = (String) payload.get('name');
        dto.title = (String) payload.get('title');
        dto.titleEn = (String) payload.get('titleEn');
        dto.bio = (String) payload.get('bio');
        dto.bioEn = (String) payload.get('bioEn');
        dto.profileImageUrl = (String) payload.get('profileImageUrl');
        dto.linkedInUrl = (String) payload.get('linkedInUrl');
        dto.githubUrl = (String) payload.get('githubUrl');
        dto.trailheadUrl = (String) payload.get('trailheadUrl');
        dto.email = (String) payload.get('email');
        dto.phone = (String) payload.get('phone');
        dto.whatsappPhone = (String) payload.get('whatsappPhone');
        dto.yearsExperience = toDecimal(payload.get('yearsExperience'));
        dto.location = (String) payload.get('location');
        return dto;
    }

    private static List<String> toStringList(Object value) {
        List<String> output = new List<String>();
        if (value == null) {
            return output;
        }

        List<Object> raw = (List<Object>) value;
        for (Object item : raw) {
            if (item != null) {
                output.add(String.valueOf(item));
            }
        }
        return output;
    }

    private static Integer toInteger(Object value) {
        if (value == null) {
            return null;
        }

        try {
            return Integer.valueOf(String.valueOf(value));
        } catch (Exception ex) {
            throw new PortfolioService.ValidationException('Invalid integer field value in request body.');
        }
    }

    private static Decimal toDecimal(Object value) {
        if (value == null) {
            return null;
        }

        try {
            return Decimal.valueOf(String.valueOf(value));
        } catch (Exception ex) {
            throw new PortfolioService.ValidationException('Invalid decimal field value in request body.');
        }
    }

    private static Boolean toBoolean(Object value) {
        if (value == null) {
            return null;
        }

        return String.valueOf(value).toLowerCase() == 'true';
    }

    private static Route parseRoute() {
        String uri = RestContext.request.requestURI;
        Integer markerIndex = uri == null ? -1 : uri.toLowerCase().indexOf('/portfolio/');
        if (markerIndex < 0) {
            return new Route();
        }

        String relative = uri.substring(markerIndex + '/portfolio/'.length());
        List<String> rawSegments = relative.split('/');
        List<String> segments = new List<String>();

        for (String segment : rawSegments) {
            if (!String.isBlank(segment)) {
                segments.add(segment);
            }
        }

        Route route = new Route();
        if (segments.isEmpty()) {
            return route;
        }

        route.resource = segments[0].toLowerCase();
        if (segments.size() > 1) {
            route.recordId = PortfolioService.parseId(segments[1], 'id');
        }

        return route;
    }

    private static void respondSuccess(Integer statusCode, Object data) {
        Map<String, Object> payload = new Map<String, Object>{
            'success' => true,
            'data' => data
        };
        respond(statusCode, payload);
    }

    private static void respondError(Integer statusCode, String message) {
        Map<String, Object> payload = new Map<String, Object>{
            'success' => false,
            'error' => String.isBlank(message) ? 'Unexpected error.' : message
        };
        respond(statusCode, payload);
    }

    private static void respond(Integer statusCode, Map<String, Object> payload) {
        RestContext.response.statusCode = statusCode;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(payload));
    }

    private class Route {
        public String resource;
        public Id recordId;
    }
}
