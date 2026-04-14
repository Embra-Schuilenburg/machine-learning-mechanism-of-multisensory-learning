# Helper to load saved runs for modeling later

def load_saved_run(npz_path):
    """
    Load one saved run and return arrays for training.
    """
    data = np.load(npz_path, allow_pickle=True)
    X = data['X']                            # (n_trials, n_rois)
    y_joint = data['y']                      # (n_trials, 2)
    y_surprise = y_joint[:, 0]               # (n_trials,)
    y_V = y_joint[:, 1]                      # (n_trials,)
    roi_names = data['roi_names']
    y_names = data['y_names']
    return X, y_joint, y_surprise, y_V, roi_names, y_names
