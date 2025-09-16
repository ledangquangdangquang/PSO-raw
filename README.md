# PSO-raw (MATLAB)

A MATLAB implementation of a parameter estimation pipeline using Particle Swarm Optimization (PSO) for a multi-antenna system. The workflow estimates pulse delay, direction parameters, Doppler, and complex amplitude iteratively, updating the residual after each step.

### Prerequisites
- MATLAB R2020a or newer (Signal Processing Toolbox recommended)
- OS: Windows/Linux/macOS
- Repository contents placed in a single folder (this folder)

### Data files
- `IR_12.mat`: Measured/received impulse responses per antenna (matrix). The script uses the first `M` columns.
- `VA.mat`: Additional data used by the project (loaded in `all25.m`).
- `pos.mat`: Contains `pos_centers` used to compute array responses.

Make sure these files are present in the project root.

### Main workflow
Run `all25.m`. It performs 25 sequential estimation steps:
1. Load `IR_12.mat`, `VA.mat`, and `pos.mat`. Set global params: number of antennas `M=5`, pulse model `md` (type RRC, `Tp`, `beta`), and time grid `tau`.
2. For each step (1..25):
   - Estimate delay `tau_0` via PSO: `psoT(IR_3, tau)`.
   - Generate normalized pulse `u = generatePulse(md, tau_0, tau, 2)` and log its power.
   - Estimate direction parameters via PSO: `[phi_1, theta_1, omega_1] = psoOmega_1(u, IR_3, tau)`.
   - Estimate Doppler `v` via PSO: `psoV(u, IR_3, omega_1, theta_1, tau)`.
   - Estimate complex amplitude `alpha` by closed-form scaling: `alpha_1(...)`.
   - Update residual channel: `IR_3 = calculate_XL_omega_1(u, IR_3, omega_1, theta_1, alpha, v)`.

Intermediate results are printed to the console. `calculate_XL_omega_1` also plots per-antenna signals and the modeled component for inspection.

### Quick start
1. Open MATLAB and set the current folder to this project directory.
2. Ensure `IR_12.mat`, `VA.mat`, and `pos.mat` exist here.
3. Run:
   ```matlab
   all25
   ```

### Key scripts and functions
- `all25.m`: Orchestrates the 25-step estimation loop and logging.
- `psoT.m`: PSO to estimate delay `tau_0` maximizing `objective_function_tau`.
- `psoOmega_1.m`: PSO to estimate angles `[phi_1, theta_1]` and unit vector `omega_1` maximizing `objective_function_omega_1`.
- `psoV.m`: PSO to estimate Doppler `v` maximizing `objective_function_v`.
- `alpha_1.m`: Computes complex amplitude scaling using pulse power and array response.
- `calculate_XL_omega_1.m`: Builds modeled signal for the estimated parameters and computes residual `IR_12 - s`; generates diagnostic plots.
- `generatePulse.m`: Generates RC/RRC pulse and its derivatives; supports several normalization modes (0: none, 1: max, 2: energy, 3: energy with `tau`).
- `objective_function_tau.m`: Correlates `u(md, tau_0)` with `IR_3` across antennas and sums energies.
- `objective_function_omega_1.m`: Uses array response `calculate_c_omega_1` to form matched filter and maximizes squared magnitude of the integral.
- `objective_function_v.m`: Adds Doppler term `exp(-j 2π v τ)` to matched filtering and maximizes magnitude.
- `calculate_c_omega_1.m`: Builds array response vector `c(ω, θ)` from `pos_centers` for antennas indexed 11..20.
- `calculate_power.m`: Average power of a signal vector.
- `sigEnergy.m`: Signal energy (optionally weighted by `tau` step).
- `test.m`: Example script to visualize generated pulses and normalization options.

### Globals and parameters
- Globals used: `md` (pulse model structure), `M` (number of antennas), `pos_centers` (array geometry).
- Default values in `all25.m`: `M = 5`, `md.type = 'RRC'`, `md.Tp = 0.5e-9`, `md.beta = 0.6`.
- Time grid: `tau = 0 : 4.6414e-12 : 14999*4.6414e-12` (length 15000).

### Notes and tips
- Random seeds: `psoOmega_1` uses `rng(0)`, `psoV` uses `rng(5)` for reproducibility.
- Plot windows may open during `calculate_XL_omega_1`. Close them or disable plotting by editing that function if running headless.
- If you change `M` or `pos_centers`, update `calculate_c_omega_1` (antenna indices `11:20`) accordingly.

### Citing or extending
- This code can be extended to multi-component extraction by repeating the loop and/or modeling additional paths (`omega_2`, `theta_2`, etc.).
- For research use, please cite your adapted method accordingly.
