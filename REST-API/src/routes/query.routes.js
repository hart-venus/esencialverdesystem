import { Router } from "express";

import { getProducers } from "../controllers/query.controller";

const router = Router();

router.get('/producers', getProducers);

export default router;