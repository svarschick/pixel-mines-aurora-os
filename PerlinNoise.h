#ifndef PERLINNOISE_H
#define PERLINNOISE_H

#include <math.h>
#include <array>
#include <utility>
#include <random>
#include <cstddef>

namespace minesweeper {

class PerlinNoise {

public:

    using float_ty = float;
    using int_ty   = int;
    using vec2     = std::array<float_ty, 2>;

public:

    static float_ty quanticCurve(float_ty t) {
        return t * t * t * (t * (t * 6 - 15) + 10);
    }
    static float_ty scalarVector(const vec2& a, const vec2& b) {
        return a[0] * b[0] + a[1] * b[1];
    }
    static float_ty lerp(float_ty a, float_ty b, float_ty t) {
        return a + (b - a) * t;
    }
    static int_ty discretize(float_ty v, int_ty n) {
        return static_cast<int_ty>(v * (n - 1));
    }

public:

    PerlinNoise(int_ty seed = 200) : permutationTable{} {
        std::mt19937 engine(seed); // Mersenne Twister engine
        std::uniform_int_distribution<int_ty> dist;

        for (std::size_t i = 0; i < sizeof(permutationTable); ++i) {
            permutationTable[i] = dist(engine);
        }
    }
    vec2 getGradientVector(int_ty x, int_ty y) {
        int_ty v = static_cast<int>((((x * 1836311903) ^ (y * 2971215073) + 4807526976) & 1023));
        v = permutationTable[v] & 0b11;
        return gradientVectors[v];
    }
    float_ty Noise(float_ty fx, float_ty fy) {
        int_ty left = static_cast<int_ty>(std::floor(fx));
        int_ty top  = static_cast<int_ty>(std::floor(fy));

        float_ty pointInQuadX = fx - left;
        float_ty pointInQuadY = fy - top;

        vec2 topLeftGradient       = getGradientVector(left,      top    );
        vec2 topRightGradient      = getGradientVector(left + 1,  top    );
        vec2 bottomLeftGradient    = getGradientVector(left,      top + 1);
        vec2 bottomRightGradient   = getGradientVector(left + 1,  top + 1);

        vec2 distanceToTopLeft     = vec2{ pointInQuadX,     pointInQuadY     };
        vec2 distanceToTopRight    = vec2{ pointInQuadX - 1, pointInQuadY     };
        vec2 distanceToBottomLeft  = vec2{ pointInQuadX,     pointInQuadY - 1 };
        vec2 distanceToBottomRight = vec2{ pointInQuadX - 1, pointInQuadY - 1 };

        float_ty tx1 = scalarVector(distanceToTopLeft,    topLeftGradient    );
        float_ty tx2 = scalarVector(distanceToTopRight,   topRightGradient   );
        float_ty bx1 = scalarVector(distanceToBottomLeft,  bottomLeftGradient );
        float_ty bx2 = scalarVector(distanceToBottomRight, bottomRightGradient);

        pointInQuadX = quanticCurve(pointInQuadX);
        pointInQuadY = quanticCurve(pointInQuadY);

        float_ty tx = lerp(tx1, tx2, pointInQuadX);
        float_ty bx = lerp(bx1, bx2, pointInQuadX);
        float_ty tb = lerp(tx,  bx,  pointInQuadY);

        return std::max(-1.0f, std::min(1.0f, tb));
    }
    float_ty Noise(float_ty fx, float_ty fy, int_ty octaves, float_ty persistence = 0.5) {
        float_ty amplitude = 1;
        float_ty max = 0;
        float_ty result = 0;

        while (octaves-- > 0) {
            max += amplitude;
            result += Noise(fx, fy);
            amplitude *= persistence;
            fx *= 2;
            fy *= 2;
        }

        return result / max;
    }

private:
    const std::array<vec2, 4> gradientVectors = {
        vec2{  1,  0 },
        vec2{ -1,  0 },
        vec2{  0,  1 },
        vec2{  0, -1 }
    };
    std::uint8_t permutationTable[1024];
};

}

#endif // PERLINNOISE_H
