<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Visibility extends Model
{
    use HasFactory;

    protected $table = 'visibility_types';

    protected $fillable = [
        'type'
    ];

    public function letter(): HasMany
    {
        return $this->HasMany(Letter::class);
    }
}
