<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

/**
 * @OA\Info(
 *      version="1.0.0",
 *      title="Minnemi API",
 *      description="Documentação das APIs para interação com a aplicação Minnemi",
 *     @OA\License(
 *         name="Apache 2.0",
 *         url="https://www.apache.org/licenses/LICENSE-2.0.html"
 *     ),    
 * ),
 * @OA\SecurityScheme(type="http", scheme="bearer", securityScheme="bearerAuth",),
 */
class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;
}
